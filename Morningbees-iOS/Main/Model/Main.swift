//
//  BeeInfo.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/05/08.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

struct MainModel: RequestModel {
    typealias ModelType = Main
    var method: HTTPMethod = .get
    var path: Path = .main
}

struct Main: Codable {
    let missions: [Missions]
    let beeInfos: [BeeInfos]
}

struct Missions: Codable {
    let missionID: Int
    let imageURL: String
    let nickname: String
    let type: Int
    let difficulty: Int
    let createdAt: String
    let agreeCount: Int
    let disagreeCount: Int
}

struct BeeInfos: Codable {
    let totalPenalty: Int
    let memberCounts: Int
    let todayQuestioner: String
    let todayDifficulty: Int
    let startTime: Int
    let endTime: Int
    let title: String
    let nextQuestioner: String
}

struct MainParameter: Codable {
    let targetDate: String
    let beeId: Int
}
