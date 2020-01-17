//
//  ValidNickname.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/12/27.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import Foundation

struct ValidNicknameModel: RequestModel {
    typealias ModelType = ValidNickname
    var method: HTTPMethod = .get
    var path: Path = .validNickname
}

struct ValidNickname: Codable {
    let isValid: Bool
}
