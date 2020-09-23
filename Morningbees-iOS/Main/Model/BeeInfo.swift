//
//  BeeInfo.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/05/08.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

struct BeeInfoModel: RequestModel {
    typealias ModelType = BeeInfo
    var method: HTTPMethod = .get
    var path: Path = .beeInfo
}

struct BeeInfo: Codable {
    let isManager: Bool
    let title: String
    let missionTime: String
    let totalPay: Int
    let todayUser: String
}
