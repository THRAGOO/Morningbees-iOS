//
//  KeychainItems.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2020/02/15.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

enum KeychainServer: String {
    case morningbeesAuth = "https://api-morningbees.thragoo.com/auth"
}

struct Credentials {
    var accessToken: String
    var refreshToken: String
}

struct AppleCredentials {
    var userID: String
    var identityToken: String
}

struct BeeCredentials {
    var beeId: Int
}
