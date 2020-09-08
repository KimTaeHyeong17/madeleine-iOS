//
//  SignupModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/19.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation

class SignupModel {
    var first_name = ""
    var last_name = ""
    var email = ""
    var validateNumber = ""
    var password = ""
    var passwordConfirm = ""
    var birthDay = ""
    var gender = false
    
    convenience init(first_name: String, last_name : String, email: String, validateNumber: String, password: String, passwordConfirm: String, birthDay : String) {
        self.init()
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.validateNumber = validateNumber
        self.password = password
        self.passwordConfirm = passwordConfirm
        self.birthDay = birthDay
    }
}

