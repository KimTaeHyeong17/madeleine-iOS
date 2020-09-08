//
//  CurationModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/19.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation

struct CurationResponseModel : Decodable {
    let status : String?
    let message : String?
    let value : [CurationModel]?
}
struct CurationModel : Decodable {
    let page_pk : Int?
    let page_title : String?
    let page_content : String?
    let page_intro_title : String?
    let page_intro_content : String?
    let page_image : String?
    let page_tags : [String]?
}
