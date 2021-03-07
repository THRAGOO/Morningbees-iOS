//
//  RenewalRequest.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/03/22.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class RenewalToken {
    
    func request(completion: @escaping (Bool, CustomError?) -> Void) {
        let requestModel = RenewalModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let renewalRequest = Request<Renewal>()
        
        KeychainService.extractKeyChainToken { (accessToken, refreshToken, error) in
            if let error = error {
                completion(false, error)
            }
            guard let accessToken = accessToken,
                  let refreshToken = refreshToken else {
                let error = CustomError(errorType: .foundNil, description: ErrorDescription.foundNil.rawValue)
                completion(false, error)
                return
            }
            let headers: [String: String] = [RequestHeader.accessToken.rawValue: accessToken,
                                             RequestHeader.refreshToken.rawValue: refreshToken]
            renewalRequest.request(request: request, header: headers, parameter: "") { (renewal, _, error) in
                if let error = error {
                    completion(false, error)
                    return
                }
                guard let renewal = renewal else {
                    completion(false, nil)
                    return
                }
                KeychainService.updateKeychainToken(renewal.accessToken, refreshToken) { (error) in
                    if let error = error {
                        completion(false, error)
                    }
                }
            }
            completion(true, nil)
        }
    }
}
