//
//  LoginVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/15.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var findIdButton: UIButton!
    @IBOutlet weak var findPWButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var isAutoLogin: UISwitch!
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        createViewModelBinding()
        createCallBacks()

    }
    
    func setupUI(){
        self.hideKeyboardWhenTappedAround()
        emailTextField.addTextFieldIcon(UIImage(named: "ic_login_email")!)
        passwordTextField.addTextFieldIcon(UIImage(named: "ic_login_password")!)
   
        loginButton.layer.cornerRadius = 5
        emailTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        
        if UserDefaults.standard.bool(forKey: "autoLogin") {
            isAutoLogin.setOn(true, animated: false)
        }else{
            isAutoLogin.setOn(false, animated: false)
        }
        
    }
    func createViewModelBinding() {
        //이메일 입력
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: disposeBag)
        
        //비밀번호 입력
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
            .disposed(by: disposeBag)
    
        //로그인 버튼
        loginButton.rx.tap.do(onNext: { [unowned self] in
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
        }).subscribe(onNext: { [unowned self] in
            if self.viewModel.validateCredentials() {
                self.viewModel.login()
            }else{
                self.alert(title: "\(self.viewModel.emailViewModel.errorValue.value ?? "")\(self.viewModel.passwordViewModel.errorValue.value ?? "")")
            }
        }).disposed(by: disposeBag)
        
        //가입하기 버튼
        signInButton.rx.tap.do(onNext: {[unowned self] in
            self.emailTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
        }).subscribe(onNext: {[unowned self] in
            let SignInStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
            let SignInVC = SignInStoryboard.instantiateViewController(identifier: "SignInVC")
            SignInVC.modalPresentationStyle = .overFullScreen
            self.present(SignInVC, animated: true, completion: nil)
        
        }).disposed(by: disposeBag)
    }
    func createCallBacks() {
        viewModel.isSuccess.asObservable()
            .bind{ value in
                print(value)
                print("success callback binded")
        }.disposed(by: disposeBag)
        
        viewModel.errorMsg.asObservable()
            .bind{ errorMessage in
                self.alert(title: errorMessage)
                print("fail callback binded")
        }.disposed(by: disposeBag)
    }
    
    @IBAction func actionFindID(_ sender: Any) {
        let alertController = UIAlertController(title: "아이디 찾기", message: "생년월일과 이름을 입력해 주세요", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "이름을 입력해 주세요"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "생년월일(0000-00-00)"
        }
        
        let saveAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            if firstTextField.text != nil && secondTextField.text != nil {
                self.findID(firstTextField.text! , secondTextField.text!)
            }
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
      
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
    @IBAction func actionFindPW(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "FindPasswordVC") as? FindPasswordVC
        vc?.modalPresentationStyle = .overFullScreen
        present(vc!,animated: true)
    }
    
    //API
    private func findID(_ name : String, _ birth : String){
        if name == "" {
            self.alert(title: "이름을 입력해 주세요.")
            return
        }
        if birth == "" {
            self.alert(title: "생년월일을 입력해 주세요")
            return 
        }
        let last_name = String(name[name.index(from: 0)])
        let first_name = String(name.dropFirst())
        let parameters : Parameters = [
            "first_name" : first_name,
            "last_name" : last_name,
            "birth" : birth
        ]
        ApiService.shared.findID(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(StringResponse.self, from : data)
                if res.status == "S00" {
                    self.dismiss(animated: true) {
                        Utils.showAlertMessage(vc: self, titleStr: "아이디", messageStr: res.value ?? "")
                    }
                }else{
                    Utils.showAlertMessage(vc: self, titleStr: "실패", messageStr: res.message ?? "")
                }
            }catch {
                Utils.showAlertMessage(vc: self, titleStr: "실패", messageStr: "실패 response 고쳐야함")

                print(error.localizedDescription)
                print("error")
            }
        })
        
    }
    
    @IBAction func switchAutoLogin(_ sender: Any) {
        if isAutoLogin.isOn {
            UserDefaults.standard.set(true, forKey: "autoLogin")
        }else{
            UserDefaults.standard.set(false, forKey: "autoLogin")
        }
    }
}
