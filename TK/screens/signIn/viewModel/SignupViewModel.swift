//
//  SignupViewModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/19.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class SignupViewModel {
    let disposeBag = DisposeBag()
    let model : SignupModel = SignupModel()
    
    let emailViewModel = EmailViewModel()
    let passwordViewModel = PasswordViewModel()
    
    let nameRelay : BehaviorRelay<String> = BehaviorRelay(value : "")
    let validationCodeRelay : BehaviorRelay<String> = BehaviorRelay(value : "")
    let passwordConfirmRelay : BehaviorRelay<String> = BehaviorRelay(value : "")
    let birthDayRelay : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let isSuccess : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let isLoading : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let errorMsg : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let isEmailSended : BehaviorRelay<Bool> = BehaviorRelay(value : false)
    let isEmailValidated : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let isSignupCompleted : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let serverMessageRelay : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func validateCredentials() -> Bool {
        return emailViewModel.validateCredentials() && passwordViewModel.validateCredentials()
    }
    func validateEmail() {
        model.email = emailViewModel.data.value
        model.validateNumber = validationCodeRelay.value
    }
    func genderSelect(_ selected : Bool){
        model.gender = selected
    }
    
    func sendValidationMail(){
        model.email = emailViewModel.data.value
        let parameters : Parameters = [
            "username" : model.email
        ]
        ApiService.shared.sendValidationMail(parameters: parameters, completion: { (data) -> (Void) in
            do{
                let res = try JSONDecoder().decode(RequestCodeResponseModel.self,from: data)
                if res.status == "S00"{
                    self.serverMessageRelay.accept(res.message ?? "")
                    self.isEmailSended.accept(true)
                }else{
                    self.serverMessageRelay.accept(res.message ?? "")
                    self.isEmailSended.accept(false)
                }
            }catch {
                print("error")
            }
        })
    }
    func confirmEmail(){
        model.email = emailViewModel.data.value
        model.validateNumber = validationCodeRelay.value
        let parameters : Parameters = [
            "username" : model.email,
            "email_check" : model.validateNumber
        ]
        ApiService.shared.confirmEmail(parameters: parameters, completion: { (data) -> (Void) in
            do{
                let res = try JSONDecoder().decode(RequestCodeResponseModel.self,from: data)
                  if res.status == "S00"{
                    self.serverMessageRelay.accept(res.message ?? "")
                      self.isEmailValidated.accept(true)
                  }else{
                    self.serverMessageRelay.accept(res.message ?? "")
                      self.isEmailValidated.accept(false)
                  }
              }catch {
                  print("error")
              }
          })
      }
    func signupUser(){
        model.email = emailViewModel.data.value
        model.password = passwordViewModel.data.value
        model.passwordConfirm = passwordConfirmRelay.value
        model.birthDay = birthDayRelay.value
        model.validateNumber = validationCodeRelay.value
        let name = nameRelay.value
        model.last_name = String(name[name.index(from: 0)])
        model.first_name = String(name.dropFirst())
        dump(model)
        let parameters : Parameters = [
            "username" : model.email,
            "password" : model.password,
            "birth" : model.birthDay,
            "gender" : model.gender,
            "email_check" : model.validateNumber,
            "first_name" : model.first_name,
            "last_name" : model.last_name,
        ]
        ApiService.shared.signUp(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(SignUpResponseModel.self, from : data)
                if res.status == "S00" {
                    self.isSignupCompleted.accept(true)
                    self.serverMessageRelay.accept(res.message ?? "")
                }else{
                    self.isSignupCompleted.accept(false)
                    self.serverMessageRelay.accept(res.message ?? "")
                }
            }catch{
                print(data.description)
                print("error")
            }
        })
        
    }
}
