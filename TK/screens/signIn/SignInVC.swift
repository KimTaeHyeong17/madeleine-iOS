//
//  SignInVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/17.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInVC: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfValidationCode: UITextField!
    @IBOutlet weak var tfPw: UITextField!
    @IBOutlet weak var tfPwConfirm: UITextField!
    @IBOutlet weak var tfBirthday: UITextField!
    
    @IBOutlet weak var btnValidate: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    let viewModel = SignupViewModel()
    let disposeBag = DisposeBag()
    
    var datePicker : UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createViewModelBinding()
        createCallBacks()
        
    }
    
    private func setupUI(){
        self.hideKeyboardWhenTappedAround()
        
        
        tfName.layer.cornerRadius = 5
        tfEmail.layer.cornerRadius = 5
        tfValidationCode.layer.cornerRadius = 5
        tfPw.layer.cornerRadius = 5
        tfPwConfirm.layer.cornerRadius = 5
        tfBirthday.layer.cornerRadius = 5
        
        btnValidate.layer.cornerRadius = 5
        btnNext.layer.cornerRadius = 5
        btnMale.layer.cornerRadius = 5
        btnFemale.layer.cornerRadius = 5
        btnConfirm.layer.cornerRadius = 5
        
        tfName.setLeftPaddingPoints(15)
        tfEmail.setLeftPaddingPoints(15)
        tfValidationCode.setLeftPaddingPoints(15)
        tfPw.setLeftPaddingPoints(15)
        tfPwConfirm.setLeftPaddingPoints(15)
        tfBirthday.setLeftPaddingPoints(15)
        
        btnNext.isEnabled = false
        btnNext.backgroundColor = .gray
        
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        tfBirthday.inputView = datePicker
        let doneButton = UIBarButtonItem.init(title: "확인", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        tfBirthday.inputAccessoryView = toolBar
        
    }
    @objc func datePickerDone() {
        tfBirthday.resignFirstResponder()
    }
    
    @objc func dateChanged() {
        //10자리
        tfBirthday.text = "\(datePicker.date)".substring(to: 10)
    }
    private func createViewModelBinding(){
        tfName.rx.text.orEmpty
            .bind(to: viewModel.nameRelay)
            .disposed(by: disposeBag)
        tfEmail.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: disposeBag)
        tfValidationCode.rx.text.orEmpty
            .bind(to: viewModel.validationCodeRelay)
            .disposed(by: disposeBag)
        tfPw.rx.text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
            .disposed(by: disposeBag)
        tfPwConfirm.rx.text.orEmpty
            .bind(to: viewModel.passwordConfirmRelay)
            .disposed(by: disposeBag)
        tfBirthday.rx.text.orEmpty
            .bind(to: viewModel.birthDayRelay)
            .disposed(by: disposeBag)
        
        //인증메일 발송버튼
        btnValidate.rx.tap.do(onNext: {[unowned self] in
            self.resignAllFirstResponder()
        }).subscribe(onNext: {[unowned self] in
            self.viewModel.sendValidationMail()
        }).disposed(by: disposeBag)
        
        //인증메일 확인
        btnConfirm.rx.tap.do(onNext: {[unowned self] in
            self.resignAllFirstResponder()
        }).subscribe(onNext: {[unowned self] in
            self.viewModel.confirmEmail()
        }).disposed(by: disposeBag)
        
        //회원가입버튼
        btnNext.rx.tap.do(onNext: {[unowned self] in
            self.resignAllFirstResponder()
        }).subscribe(onNext: {[unowned self] in
            if self.viewModel.validateCredentials() {
                self.viewModel.signupUser()
            }else {
                self.alert(title: "\(self.viewModel.emailViewModel.errorValue.value ?? "")\(self.viewModel.passwordViewModel.errorValue.value ?? "")")
            }
        }).disposed(by: disposeBag)
        
        btnMale.rx.tap.do(onNext: {[unowned self] in
            self.resignAllFirstResponder()
        }).subscribe(onNext: {[unowned self] in
            self.viewModel.genderSelect(true)
            self.btnMale.backgroundColor = UIColor(named: "color_pink_main")
            self.btnFemale.backgroundColor = .darkGray
        }).disposed(by: disposeBag)
        
        btnFemale.rx.tap.do(onNext: {[unowned self] in
            self.resignAllFirstResponder()
        }).subscribe(onNext: {[unowned self] in
            self.viewModel.genderSelect(false)
            self.btnMale.backgroundColor = .darkGray
            self.btnFemale.backgroundColor = UIColor(named: "color_pink_main")
        }).disposed(by: disposeBag)
        
    }
    private func createCallBacks() {
        viewModel.isSuccess.asObservable()
            .bind{ value in
                print("success callback binded")
        }.disposed(by: disposeBag)
        
        viewModel.errorMsg.asObservable()
            .bind{ errorMessage in
                print("fail callback binded")
        }.disposed(by: disposeBag)
        
        //이메일 발송되었을떄 버튼 처리
        viewModel.isEmailSended.asObservable()
            .debug()
            .bind { value in
                if value {
                    self.btnValidate.isEnabled = false
                    self.btnValidate.titleLabel?.text = "발송성공"
                    self.btnValidate.backgroundColor = .gray
                    self.alert(title: "인증메일이 발송되었습니다.")
                }
        }.disposed(by: disposeBag)
        
        //이메일 인증번호 확인
        viewModel.isEmailValidated.asObservable()
            .bind {value in
                if value {
                    //인증성공
                    self.btnValidate.isEnabled = false
                    self.btnConfirm.isEnabled = false
                    self.btnConfirm.titleLabel?.text = "완료"
                    self.btnConfirm.backgroundColor = .gray
                    self.btnNext.isEnabled = true
                    self.tfEmail.isEnabled = false
                    self.btnNext.backgroundColor = UIColor(named: "color_pink_main")
                }
        }.disposed(by: disposeBag)
        
        //가입 완료 콜백
        viewModel.isSignupCompleted.asObservable()
            .bind { value in
                if value {
                    self.alert(title: "회원가입 완료", message: "회원가입 완료", okTitle: "확인", okHandler: nil, cancelTitle: "확인", cancelHandler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }, completion: nil)
                }
        }.disposed(by: disposeBag)
        
        //오류 메시지 토스트
        viewModel.serverMessageRelay.asObservable()
            .bind {value in
                self.alert(title: value)
        }.disposed(by: disposeBag)
        
        
    }
    private func resignAllFirstResponder(){
        tfName.resignFirstResponder()
        tfEmail.resignFirstResponder()
        tfValidationCode.resignFirstResponder()
        tfPw.resignFirstResponder()
        tfPwConfirm.resignFirstResponder()
        tfBirthday.resignFirstResponder()
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

