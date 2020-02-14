//
//  SignIn.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2020/01/21.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

enum SignInProvider: String {
    case naver = "naver"
    case google = "google"
}

struct SignInModel: RequestModel {
    typealias ModelType = SignIn
    var method: HTTPMethod = .post
    var path: Path = .signIn
}

struct SignIn: Codable {
    let accessToken: String
    let refreshToken: String
    let type: Int
}
