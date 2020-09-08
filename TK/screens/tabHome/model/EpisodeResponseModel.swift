//
//  EpisodeResponseModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/20.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation

struct EpisodeResponseModel : Decodable {
    let status : String?
    let message : String?
    let value : [EpisodeModel]?
}
struct EpisodeModel : Decodable {
    let episode_pk : Int?
    let newsletter_pk : Int?
    let episode_title : String?
    let episode_date : String?
    let episode_url : String?
}
