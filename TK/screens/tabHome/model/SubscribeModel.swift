//
//  SubscribeModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/16.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation

struct SubscribeModel : Decodable {
    let newsletter_pk : Int?
    let newsletter_name : String?
    let newsletter_image : String?
    let register_url : String?
    let newsletter_explain : String?
    let newsletter_tags : [TagModel]?
    let followers : Int?
}
