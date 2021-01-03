//
//  RenewalRequest.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/03/22.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class RenewalToken {
    
    func request(completion: @escaping (Bool?, Error?) -> Void) {
        let requestModel = RenewalModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let renewalRequest = Request<Renewal>()
        
        KeychainService.extractKeyChainToken { (accessToken, refreshToken, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let accessToken = accessToken,
                let refreshToken = refreshToken else {
                    print(KeychainError.noToken)
                    return
            }
            let headers: [String: String] = [RequestHeader.accessToken.rawValue: accessToken,
                                             RequestHeader.refreshToken.rawValue: refreshToken]
            renewalRequest.request(req: request, header: headers, param: "") { (renewal, _, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let renewal = renewal else {
                    completion(false, nil)
                    return
                }
                KeychainService.updateKeychainToken(renewal.accessToken, refreshToken) { (error) in
                    if let error = error {
                        completion(nil, error)
                    }
                }
            }
            completion(true, nil)
        }
    }
}
