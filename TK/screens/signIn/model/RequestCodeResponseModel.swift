//
//  requestCodeResponseModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/21.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation

struct RequestCodeResponseModel : Decodable {
    let status : String?
    let message : String?
    let value : String?
}
