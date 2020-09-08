//
//  CurationDetailModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/19.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation

struct CurationDetailResponseModel : Decodable{
    let status : String?
    let message : String?
    let value : CurationDetailModel?
}
struct CurationDetailModel : Decodable {
    let page_pk : Int?
    let page_title : String?
    let page_content : String?
    let page_intro_title : String?
    let page_intro_content : String?
    let page_image : String?
    let curations : [CurationInfoModel]?
}
struct CurationInfoModel : Decodable {
    let curation_pk : Int?
    let curation_title : String?
    let curation_explain : String?
    let curation_newsletter_pk : Int?
}

