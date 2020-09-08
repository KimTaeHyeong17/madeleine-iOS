//
//  TagModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/15.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation

struct TagModelResponse : Decodable {
    let status : String?
    let message : String?
    let value : [TagModel]?
}
struct TagModel : Decodable {
    let tag_pk : Int?
    let tag_name : String?
    let tag_image : String?
}
