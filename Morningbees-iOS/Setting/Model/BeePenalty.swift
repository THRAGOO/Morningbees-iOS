//
//  BeePenalty.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/02/05.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import Foundation

enum PenaltyTableLabel: String {
    case unpaid = "미납 로얄젤리"
    case paid = "총 로얄젤리"
}

struct BeePenaltyModel: RequestModel {
    typealias ModelType = BeePenalty
    var method: HTTPMethod = .get
    var path: Path = .beePenalty
}

struct BeePenalty: Codable {
    let penaltyHistories: [History]
    let penalties: [Penalty]
}

struct History: Codable {
    let status: Int
    let total: Int
}

struct Penalty: Codable {
    let nickname: String
    let userId: Int
    let penalty: Int
}
