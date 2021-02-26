//
//  Members.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/09.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import Foundation

enum DynamicLinkItem: String {
    case uriPrefix = "https://thragoo.page.link"
    case appStoreId = "454943023"
    case androidPackage = "com.jasen.kimjaeseung.morningbees"
}

struct MembersModel: RequestModel {
    typealias ModelType = Members
    var method: HTTPMethod = .get
    var path: Path = .members
}

struct Members: Codable {
    let members: [Profile]?
}
