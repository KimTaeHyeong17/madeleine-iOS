//
//  LoginModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/15.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginModel {
    
    var email = ""
    var password = ""
    
    convenience init(email: String, password: String) {
        self.init()
        self.email = email
        self.password = password
    }
}

protocol ValidationViewModel {
    var errorMessage: String {get}
    
    //Observables
    var data : BehaviorRelay<String> {get set}
    var errorValue: BehaviorRelay<String?> { get }
    
    //validatin
    func validateCredentials() -> Bool
}
