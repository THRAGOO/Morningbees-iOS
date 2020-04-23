//
//  CreateBee.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/16.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

struct CreateBeeModel: RequestModel {
    typealias ModelType = CreateBee
    var method: HTTPMethod = .post
    var path: Path = .createBee
}

struct CreateBee: Codable {
}

struct BeeCreateParam: Encodable {
    let title: String
    let startTime: Int
    let endTime: Int
    let pay: Int
    let description: String
}
