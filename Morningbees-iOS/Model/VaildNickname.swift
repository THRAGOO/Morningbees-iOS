//
//  ValidNickname.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/12/27.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import Foundation

enum NicknameAlert: String {
    case title = "Validation Check"
    case valid = "Good, You can use that nickname!"
    case notValid = "Sorry, You can not use that nickname."
    case lengthErr = "nickname's length should be between 2 and 10!"
    case regulationErr = "please put 한글, English and numbers"
}

struct ValidNickname: Codable {
    let isValid: Bool
}
