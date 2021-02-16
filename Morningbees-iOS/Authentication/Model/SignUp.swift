//
//  SignUp.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2020/02/14.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

enum NicknameValidationStatus {
    case short
    case invalidCharacter
    case alreadyInUse
    case possible
    case get
}

struct SignUpModel: RequestModel {
    typealias ModelType = SignUp
    var method: HTTPMethod = .post
    var path: Path = .signUp
}

struct SignUp: Codable {
    let accessToken: String
    let refreshToken: String
}
