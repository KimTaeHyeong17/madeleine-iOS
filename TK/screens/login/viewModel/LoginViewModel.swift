//
//  LoginViewModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/15.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import SwiftyJSON
import RxCocoa
import Alamofire

class LoginViewModel {
    let disposeBag = DisposeBag()
    let model : LoginModel = LoginModel()
    
    //init view models
    let emailViewModel = EmailViewModel()
    let passwordViewModel = PasswordViewModel()
    
    //bind to our view
    let isSuccess : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let isLoading : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let errorMsg : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func validateCredentials() -> Bool {
        return emailViewModel.validateCredentials() && passwordViewModel.validateCredentials()
    }
    
    func login(){
        //init model with value
        model.email = emailViewModel.data.value
        model.password = passwordViewModel.data.value
        let parameters : Parameters = [
            "username" : model.email,
            "password" : model.password
        ]
        ApiService.shared.login(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(LoginResponseModel.self, from : data)
                if res.status == "S00" {
                    print("로그인 성공")
                    UserDefaults.standard.set(res.value?.username, forKey: "username")
                    self.changeRootViewController()
                }else{
                    self.errorMsg.accept(res.message ?? "")
                }
            }catch {
                print("error")
            }
        })
    }
    
    
    func changeRootViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
}


