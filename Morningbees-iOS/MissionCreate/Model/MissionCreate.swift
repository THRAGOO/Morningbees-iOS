//
//  MissionCreate.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/05/15.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

struct MissionCreateModel: RequestModel {
    typealias ModelType = MissionCreate
    var path: Path = .missionCreate
    var method: HTTPMethod = .post
}

struct MissionCreate: Codable {
}

struct MissionCreateParam: Encodable {
    let beeId: Int
    let description: String
    let type: Int
    let difficulty: Int
}
