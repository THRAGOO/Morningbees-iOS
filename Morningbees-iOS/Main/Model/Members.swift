//
//  Members.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/09.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import Foundation

struct MembersModel: RequestModel {
    typealias ModelType = Members
    var method: HTTPMethod = .get
    var path: Path = .members
}

struct Members: Codable {
    let members: [Profile]?
}
