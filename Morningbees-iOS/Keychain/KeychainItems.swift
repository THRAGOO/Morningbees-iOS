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

struct Credentials {
    var accessToken: String
    var refreshToken: String
}
