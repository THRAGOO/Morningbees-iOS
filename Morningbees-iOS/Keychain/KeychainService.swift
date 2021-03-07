//
//  KeychainService.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2020/02/17.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

final class KeychainService {
}

// MARK:- Morningbees Token Keychain

extension KeychainService {
    
    static func addKeychainToken(_ accessToken: String,
                                 _ refreshToken: String,
                                 completion: @escaping (CustomError?) -> Void) {
        let credentials = Credentials.init(accessToken: accessToken, refreshToken: refreshToken)
        guard let accessTokenData = credentials.accessToken.data(using: String.Encoding.utf8),
              let refreshTokenData = credentials.refreshToken.data(using: String.Encoding.utf8) else {
            completion(CustomError(errorType: .unexpectedTokenData,
                                   description: ErrorDescription.unexpectedTokenData.rawValue))
            return
        }
        let tokenQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                         kSecAttrServer as String: KeychainServer.morningbeesAuth.rawValue,
                                         kSecAttrAccount as String: refreshTokenData,
                                         kSecValueData as String: accessTokenData]
        let addStatus = SecItemAdd(tokenQuery as CFDictionary, nil)
        guard addStatus == errSecSuccess else {
            completion(CustomError(errorType: .unexpectedTokenData,
                                   description: ErrorDescription.unhandledError.rawValue))
            return
        }
        completion(nil)
    }
    
    static func updateKeychainToken(_ accessToken: String,
                                    _ refreshToken: String,
                                    completion: @escaping (CustomError?) -> Void) {
        let queryToFind: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                          kSecAttrServer as String: KeychainServer.morningbeesAuth.rawValue]
        let credentials = Credentials.init(accessToken: accessToken, refreshToken: refreshToken)
        guard let accessTokenData = credentials.accessToken.data(using: String.Encoding.utf8),
              let refreshTokenData = credentials.refreshToken.data(using: String.Encoding.utf8) else {
            completion(CustomError(errorType: .unexpectedTokenData,
                                   description: ErrorDescription.unexpectedTokenData.rawValue))
            return
        }
        let queryToUpdate: [String: Any] = [kSecAttrAccount as String: refreshTokenData,
                                            kSecValueData as String: accessTokenData]
        let updateStatus = SecItemUpdate(queryToFind as CFDictionary, queryToUpdate as CFDictionary)
        guard updateStatus == errSecSuccess else {
            completion(CustomError(errorType: .unexpectedTokenData,
                                   description: ErrorDescription.unhandledError.rawValue))
            return
        }
    }
    
    static func deleteKeychainToken(completion: @escaping (CustomError?) -> Void) {
        let queryToDelete: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                            kSecAttrServer as String: KeychainServer.morningbeesAuth.rawValue]
        let deleteStatus = SecItemDelete(queryToDelete as CFDictionary)
        guard deleteStatus == errSecSuccess || deleteStatus == errSecItemNotFound else {
            completion(CustomError(errorType: .unexpectedTokenData,
                                   description: ErrorDescription.unhandledError.rawValue))
            return
        }
        completion(nil)
    }
    
    static func extractKeyChainToken(completion: @escaping (String?, String?, CustomError?) -> Void) {
        let tokenQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                         kSecAttrServer as String: KeychainServer.morningbeesAuth.rawValue,
                                         kSecMatchLimit as String: kSecMatchLimitOne,
                                         kSecReturnAttributes as String: true,
                                         kSecReturnData as String: true]
        var tokenItem: CFTypeRef?
        let matchStatus = SecItemCopyMatching(tokenQuery as CFDictionary, &tokenItem)
        guard matchStatus != errSecItemNotFound else {
            let error = CustomError(errorType: .unexpectedTokenData, description: ErrorDescription.noToken.rawValue)
            completion(nil, nil, error)
            return
        }
        guard matchStatus == errSecSuccess else {
            let error = CustomError(errorType: .unexpectedTokenData,
                                    description: ErrorDescription.unhandledError.rawValue)
            completion(nil, nil, error)
            return
        }
        guard let existingItem = tokenItem as? [String: Any],
              let accessTokenData = existingItem[kSecValueData as String] as? Data,
              let accessToken = String(data: accessTokenData, encoding: String.Encoding.utf8),
              let refreshTokenData = existingItem[kSecAttrAccount as String] as? Data,
              let refreshToken = String(data: refreshTokenData, encoding: String.Encoding.utf8)
        else {
            let error = CustomError(errorType: .unexpectedTokenData,
                                    description: ErrorDescription.unexpectedTokenData.rawValue)
            completion(nil, nil, error)
            return
        }
        let credentials = Credentials(accessToken: accessToken, refreshToken: refreshToken)
        completion(credentials.accessToken, credentials.refreshToken, nil)
    }
}
