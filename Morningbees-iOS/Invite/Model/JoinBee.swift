//
//  Join.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/09.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import Foundation

struct JoinBeeModel: RequestModel {
    typealias ModelType = JoinBee
    var method: HTTPMethod = .post
    var path: Path = .joinBee
}

struct JoinBee: Codable {
}

struct JoinBeeParameter: Codable {
    let beeId: Int
    let userId: Int
    let title: String
}
