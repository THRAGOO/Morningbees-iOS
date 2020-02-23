//
//  KeychainItems.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2020/02/15.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

enum KeychainError: Error {
    case noToken
    case unexpectedTokenData
    case unhandledError(status: OSStatus)
}

enum KeychainServer: String {
    case morningbeesAuth = "https://api-morningbees.thragoo.com/auth"
    case appleSignAuth = "https://appleid.apple.com/auth/"
}

struct Credentials {
    var accessToken: String
    var refreshToken: String
}

struct AppleCredentials {
    var userID: String
    var identityToken: String
}
