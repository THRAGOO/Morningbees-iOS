//
//  WithdrawalRequest.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/11/11.
//  Copyright © 2020 THRAGOO. All rights reserved.
//

import Foundation

final class WithdrawalAPI {
    
    func request(completion: @escaping (Bool?, Error?) -> Void) {
        let reqModel = WithdrawalModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let withdrawalRequest = Request<Withdrawal>()
        KeychainService.extractKeyChainToken { (accessToken, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let accessToken = accessToken else {
                return
            }
            let headers: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            withdrawalRequest.request(req: request, header: headers, param: "") { (_, _, error) in
                if let error = error {
                    completion(nil, error)
                }
                UserDefaults.standard.removeObject(forKey: "beeID")
                completion(true, nil)
            }
        }
    }
}
