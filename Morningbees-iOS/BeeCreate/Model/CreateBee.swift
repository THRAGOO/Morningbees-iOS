//
//  CreateBee.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/16.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

enum TimeButtonState {
    case start
    case end
}

struct BeeCreateModel: RequestModel {
    typealias ModelType = BeeCreate
    var method: HTTPMethod = .post
    var path: Path = .beeCreate
}

struct BeeCreate: Codable {
}

struct BeeCreateParam: Encodable {
    let title: String
    let startTime: Int
    let endTime: Int
    let pay: Int
    let description: String = ""
}
