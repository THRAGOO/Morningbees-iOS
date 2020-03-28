//
//  RenewalRequest.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/03/22.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

final class RenewalToken {
}

extension RenewalToken {
    static func request(accessToken: String, refreshToken: String) {
        let reqModel = RenewalModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let renewalReq = Request<Renewal>()
        let header: [String: String] = ["X-BEES-ACCESS-TOKEN": accessToken,
                                        "X-BEES-REFRESH-TOKEN": refreshToken]
        renewalReq.request(req: request, header: header, param: "") { (renewal, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let renewal = renewal else {
                return
            }
            
            KeychainService.updateKeychainToken(renewal.accessToken, refreshToken) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
