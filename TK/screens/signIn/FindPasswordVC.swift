//
//  FindPasswordVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/28.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import Alamofire
class FindPasswordVC: UIViewController {
    
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfValidation: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPasswordConfirm: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBirth: UITextField!
    
    @IBOutlet weak var btnValidate: UIButton!
    @IBOutlet weak var btnValidateConfirm: UIButton!
    @IBOutlet weak var btnFindPW: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var datePicker : UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI(){
        self.hideKeyboardWhenTappedAround()
        
        tfName.layer.cornerRadius = 5
        tfEmail.layer.cornerRadius = 5
        tfValidation.layer.cornerRadius = 5
        tfPassword.layer.cornerRadius = 5
        tfPasswordConfirm.layer.cornerRadius = 5
        tfBirth.layer.cornerRadius = 5
        
        btnValidate.layer.cornerRadius = 5
        btnValidateConfirm.layer.cornerRadius = 5
        btnFindPW.layer.cornerRadius = 5
        
        tfName.setLeftPaddingPoints(15)
        tfEmail.setLeftPaddingPoints(15)
        tfValidation.setLeftPaddingPoints(15)
        tfPassword.setLeftPaddingPoints(15)
        tfPasswordConfirm.setLeftPaddingPoints(15)
        tfBirth.setLeftPaddingPoints(15)
        
        btnFindPW.isEnabled = false
        btnFindPW.backgroundColor = .gray
        
        tfPassword.isEnabled = false
        tfPasswordConfirm.isEnabled = false
        tfBirth.isEnabled = false
        tfName.isEnabled = false
        btnFindPW.isEnabled = false
        
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        tfBirth.inputView = datePicker
        let doneButton = UIBarButtonItem.init(title: "확인", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        tfBirth.inputAccessoryView = toolBar
        
    }
    @objc func datePickerDone() {
        tfBirth.resignFirstResponder()
    }
    
    @objc func dateChanged() {
        //10자리
        tfBirth.text = "\(datePicker.date)".substring(to: 10)
    }
    private func completeEmailValidate(){
        tfEmail.isEnabled = false
        tfValidation.isEnabled = false
        
        btnFindPW.isEnabled = true
        btnFindPW.backgroundColor = UIColor(named: "color_pink_main")
        
        btnValidate.isEnabled = false
        btnValidate.backgroundColor = .gray
        
        btnValidateConfirm.isEnabled = false
        btnValidateConfirm.backgroundColor = .gray
        
        tfPassword.isEnabled = true
        tfPasswordConfirm.isEnabled = true
        tfBirth.isEnabled = true
        tfName.isEnabled = true
        btnFindPW.isEnabled = true
    }
    
    
    @IBAction func actionSendEmail(_ sender: Any) {
        sendValidationMail()
    }
    @IBAction func actionConfirmEmail(_ sender: Any) {
        confirmEmail()
    }
    
    @IBAction func actionFindPW(_ sender: Any) {
        changePassword()
    }
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //API
    func sendValidationMail(){
        let parameters : Parameters = [
            "username" : tfEmail.text ?? ""
        ]
        ApiService.shared.sendValidationMail(parameters: parameters, completion: { (data) -> (Void) in
            do{
                let res = try JSONDecoder().decode(RequestCodeResponseModel.self,from: data)
                if res.status == "S00"{
                    Utils.showAlertMessage(vc: self, titleStr: "발송성공", messageStr: "인증번호가 이메일로 발송되었습니다.")
                }else{
                    Utils.showAlertMessage(vc: self, titleStr: "오류", messageStr: res.message ?? "메일 발송에 실패했습니다. 정확한 이메일을 입력해 주세요.")
                }
            }catch {
                print("error")
            }
        })
    }
    func confirmEmail(){
        let parameters : Parameters = [
            "username" : tfEmail.text ?? "",
            "email_check" : tfValidation.text ?? ""
        ]
        ApiService.shared.confirmEmail(parameters: parameters, completion: { (data) -> (Void) in
            do{
                let res = try JSONDecoder().decode(RequestCodeResponseModel.self,from: data)
                if res.status == "S00"{
                    Utils.showAlertMessage(vc: self, titleStr: "성공", messageStr: "인증이 완료되었습니다. 비밀번호를 재설정해 주세요.")
                    self.completeEmailValidate()
                }else{
                    Utils.showAlertMessage(vc: self, titleStr: "오류", messageStr: res.message ?? "이메일 인증에 실패했습니다. 다시 진행해 주세요.")
                }
            }catch {
                print("error")
            }
        })
    }
    func changePassword(){
        if tfPassword.text != tfPasswordConfirm.text {
            Utils.showAlertMessage(vc: self, titleStr: "비밀번호 오류", messageStr: "입력하신 비밀번호가 다릅니다!")
            return
        }
        let name = tfName.text ?? ""
        let last_name = String(name[name.index(from: 0)])
        let first_name = String(name.dropFirst())
        let parameters : Parameters = [
            "username" : tfEmail.text ?? "",
            "new_password" : tfPassword.text ?? "",
            "birth" : tfBirth.text ?? "",
            "first_name" : first_name,
            "last_name" : last_name,
        ]
        ApiService.shared.changePassword(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(StringResponse.self, from : data)
                if res.status == "S00" {
                    self.alert(title: "비밀번호 변경 완료", message: "변경된 비밀번호로 로그인 해주세요.", okTitle: "확인", okHandler: nil, cancelTitle: "확인", cancelHandler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }, completion: nil)
                }else{
                    Utils.showAlertMessage(vc: self, titleStr: "오류", messageStr: res.message ?? "비밀번호 변경 실패")
                }
            }catch{
                Utils.showAlertMessage(vc: self, titleStr: "오류", messageStr: data.description)
                
                print(data.description)
                print("error")
            }
        })
        
    }
    
}
