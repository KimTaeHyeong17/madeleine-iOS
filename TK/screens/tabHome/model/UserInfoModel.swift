//
//  UserInfoModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/16.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation

struct UserInfoResponse : Decodable {
    let status : String?
    let message : String?
    let value : UserInfoModel?
}

struct UserInfoModel : Decodable {
    let pk : Int?
    let username : String?
    let birth : String?
    let gender : Bool?
    let first_name : String?
    let last_name : String?
    let like_tags : [TagModel]?
    let subscribes : [SubscribeModel]?
}

