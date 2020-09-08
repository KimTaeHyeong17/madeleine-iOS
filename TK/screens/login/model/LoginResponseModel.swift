//
//  LoginResponseModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/20.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation

struct LoginResponseModel : Decodable{
    let status : String?
    let message : String?
    let value : LoginResponseValue?
}
struct LoginResponseValue : Decodable {
    let pk : Int?
    let username : String?
    let birth : String?
    let gender : Bool?
    let first_name : String?
    let last_name : String?
}
