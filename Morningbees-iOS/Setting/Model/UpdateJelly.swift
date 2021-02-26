//
//  UpdateJelly.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/02/23.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import Foundation

struct UpdateJellyModel: RequestModel {
    typealias ModelType = UpdateJelly
    var method: HTTPMethod = .post
    var path: Path = .updateJelly
}

struct UpdateJelly: Codable {
}

struct Penalties: Codable {
    let penalties: [Penalty]
}
