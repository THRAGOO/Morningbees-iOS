//
//  KeychainService.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2020/02/17.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

final class KeychainService {
    
    static func addKeychainToken(_ accessToken: String,
                                 _ refreshToken: String,
                                 completion: @escaping (Error?) -> Void) {
        let credentials = Credentials.init(accessToken: accessToken, refreshToken: refreshToken)
        guard let accessTokenData = credentials.accessToken.data(using: String.Encoding.utf8),
            let refreshTokenData = credentials.refreshToken.data(using: String.Encoding.utf8) else {
                return
        }
        let tokenQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                         kSecAttrServer as String: Path.base.rawValue,
                                         kSecAttrAccount as String: refreshTokenData,
                                         kSecValueData as String: accessTokenData]
        let addStatus = SecItemAdd(tokenQuery as CFDictionary, nil)
        guard addStatus == errSecSuccess else {
            completion(KeychainError.unhandledError(status: addStatus))
            return
        }
        completion(nil)
    }
    
    static func updateKeychainToken(_ accessToken: String,
                                    _ refreshToken: String,
                                    completion: @escaping (Error?) -> Void) {
        let queryToFind: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                          kSecAttrServer as String: Path.base.rawValue]
        let findStatus = SecItemDelete(queryToFind as CFDictionary)
                guard findStatus == errSecSuccess ||
                    findStatus == errSecItemNotFound else {
                        completion(KeychainError.unhandledError(status: findStatus))
                        return
        }
        let credentials = Credentials.init(accessToken: accessToken, refreshToken: refreshToken)
        guard let accessTokenData = credentials.accessToken.data(using: String.Encoding.utf8),
            let refreshTokenData = credentials.refreshToken.data(using: String.Encoding.utf8) else {
                completion(KeychainError.unexpectedTokenData)
                return
        }
        let queryToUpdate: [String: Any] = [kSecAttrAccount as String: refreshTokenData,
                                            kSecValueData as String: accessTokenData]
        let updateStatus = SecItemUpdate(queryToFind as CFDictionary, queryToUpdate as CFDictionary)
        guard updateStatus == errSecSuccess else {
             completion(KeychainError.unhandledError(status: updateStatus))
                    return
        }
    }
    
    static func deleteKeychainToken(completion: @escaping (Error?) -> Void) {
        let queryToDelete: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                            kSecAttrServer as String: Path.base.rawValue]
        let deleteStatus = SecItemDelete(queryToDelete as CFDictionary)
        guard deleteStatus == errSecSuccess ||
            deleteStatus == errSecItemNotFound else {
                completion(KeychainError.unhandledError(status: deleteStatus))
                return
        }
        completion(nil)
    }
    
    static func extractKeyChainToken(completion: @escaping (String?, String?, Error?) -> Void) {
        let tokenQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                         kSecAttrServer as String: Path.base.rawValue,
                                         kSecMatchLimit as String: kSecMatchLimitOne,
                                         kSecReturnAttributes as String: true,
                                         kSecReturnData as String: true]
        var tokenItem: CFTypeRef?
        let matchStatus = SecItemCopyMatching(tokenQuery as CFDictionary, &tokenItem)
        guard matchStatus != errSecItemNotFound else {
            completion(nil, nil, KeychainError.noToken)
            return
        }
        guard matchStatus == errSecSuccess else {
            completion(nil, nil, KeychainError.unhandledError(status: matchStatus))
            return
        }
        guard let existingItem = tokenItem as? [String: Any],
            let accessTokenData = existingItem[kSecValueData as String] as? Data,
            let accessToken = String(data: accessTokenData, encoding: String.Encoding.utf8),
            let refreshTokenData = existingItem[kSecAttrAccount as String] as? Data,
            let refreshToken = String(data: refreshTokenData, encoding: String.Encoding.utf8)
        else {
            completion(nil, nil, KeychainError.unexpectedTokenData)
            return
        }
        let credentials = Credentials(accessToken: accessToken, refreshToken: refreshToken)
        completion(credentials.accessToken, credentials.refreshToken, nil)
    }
}