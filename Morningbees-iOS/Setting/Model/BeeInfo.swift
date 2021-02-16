//
//  BeeInfo.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/21.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import Foundation

struct BeeInfoModel: RequestModel {
    typealias ModelType = BeeInfo
    var method: HTTPMethod = .get
    var path: Path = .beeInfo
}

struct BeeInfo: Codable {
    let manager: Bool
    let nickname: String
    let pay: Int
    let startTime: [Int]
    let endTime: [Int]
}
