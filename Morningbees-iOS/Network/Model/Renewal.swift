//
//  Renewal.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/03/22.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

struct RenewalModel: RequestModel {
    typealias ModelType = Renewal
    var method: HTTPMethod = .post
    var path: Path = .renewal
}

struct Renewal: Codable {
    let accessToken: String
}
