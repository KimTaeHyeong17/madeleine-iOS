//
//  NewsLetterDetailModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/17.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation

struct NewsLetterDetailModel : Decodable {
    let status : String?
    let message : String?
    let value : SubscribeModel?
}
