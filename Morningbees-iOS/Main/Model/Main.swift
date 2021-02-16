//
//  BeeInfo.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/05/08.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

enum ViewPresentPeriod {
    case past
    case today
    case tomorrow
}

struct MainModel: RequestModel {
    typealias ModelType = Main
    var method: HTTPMethod = .get
    var path: Path = .main
}

struct Main: Codable {
    let missions: [Missions]
    let beeInfo: BeeInfos
}

struct Missions: Codable {
    let missionId: Int
    let missionTitle: String
    let imageUrl: String
    let nickname: String
    let type: Int
    let difficulty: Int
    let createdAt: String
    let agreeCount: Int
    let disagreeCount: Int
}

struct BeeInfos: Codable {
    let title: String
    let memberCounts: Int
    let totalPenalty: Int
    let todayDifficulty: Int?
    let startTime: Int
    let endTime: Int
    let manager: Profile
    let todayQuestioner: Profile
    let nextQuestioner: Profile
}

struct Profile: Codable {
    let id: Int
    let nickname: String
    let profileImage: String
}

struct MainParameter: Codable {
    let targetDate: String
    let beeId: Int
}
