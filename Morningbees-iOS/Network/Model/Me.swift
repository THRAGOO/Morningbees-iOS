//
//  Me.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/01.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Foundation

struct MeModel: RequestModel {
    typealias ModelType = Me
    var method: HTTPMethod = .get
    var path: Path = .me
}

struct Me: Codable {
    let nickname: String
    let alreadyJoin: Bool
    let beeId: Int
}
