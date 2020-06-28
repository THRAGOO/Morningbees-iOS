//
//  MeRequest.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/02.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class MeAPI {
}

extension MeAPI {
    
    func request(completion: @escaping (Bool?, Error?) -> Void) {
        let reqModel = MeModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let meRequest = Request<Me>()
        KeychainService.extractKeyChainToken { (accessToken, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let accessToken = accessToken else {
                return
            }
            let headers: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            meRequest.request(req: request, header: headers, param: "") { (me, error) in
                if let error = error {
                    completion(nil, error)
                }
                guard let me = me else {
                    return
                }
                KeychainService.deleteKeychainBeeIDInfo { (error) in
                    if let error = error {
                        completion(nil, error)
                    }
                }
                KeychainService.addKeychainBeeIDInfo(me.beeId) { (error) in
                    if let error = error {
                        completion(nil, error)
                    }
                }
                completion(me.alreadyJoin, nil)
            }
        }
    }
}
