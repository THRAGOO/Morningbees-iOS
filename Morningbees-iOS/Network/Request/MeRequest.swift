//
//  MeRequest.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/02.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class MeAPI {

    func request(completion: @escaping (Bool?, Error?) -> Void) {
        let reqModel = MeModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let meRequest = Request<Me>()
        KeychainService.extractKeyChainToken { (accessToken, _, error) in
            if let error = error {
                completion(nil, error)
            }
            guard let accessToken = accessToken else {
                return
            }
            let headers: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            meRequest.request(request: request, header: headers, parameter: "") { (me, _, error) in
                if let error = error {
                    completion(nil, error)
                }
                guard let me = me else {
                    return
                }
                UserDefaults.standard.set(me.nickname, forKey: UserDefaultsKey.myNickname.rawValue)
                UserDefaults.standard.set(me.beeId, forKey: UserDefaultsKey.beeId.rawValue)
                UserDefaults.standard.set(me.alreadyJoin, forKey: UserDefaultsKey.alreadyJoin.rawValue)
                UserDefaults.standard.set(me.userId, forKey: UserDefaultsKey.userId.rawValue)
                completion(me.alreadyJoin, nil)
            }
        }
    }
}
