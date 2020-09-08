//
//  PasswordViewModel.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/15.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class PasswordViewModel : ValidationViewModel {
    
    var errorMessage : String = "정확한 비밀번호를 입력해 주세요"
    
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    var errorValue: BehaviorRelay<String?> = BehaviorRelay(value: "")
    

    func validateCredentials() -> Bool {
        guard validateLength(text: data.value, size: (6,15)) else{
            errorValue.accept(errorMessage)
            return false
        }
        errorValue.accept("")
        return true
    }
    func validateLength(text: String, size: (min:Int, max:Int)) -> Bool {
        return (size.min...size.max).contains(text.count)
    }
}
