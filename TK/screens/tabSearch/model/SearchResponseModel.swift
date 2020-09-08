//
//  SearchResponseModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/20.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation

struct SearchResponseModel : Decodable {
    let status : String
    let message : String
    let value : SearchModel?
}

struct SearchModel : Decodable {
    let newsletters : [SubscribeModel]
    let tags : [TagModel]
    let episodes : [EpisodeModel]
}
