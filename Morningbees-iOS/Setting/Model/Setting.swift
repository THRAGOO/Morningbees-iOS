//
//  SettingModel.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/20.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import Foundation

enum SettingContentTitle: String {
    case missionTime = "미션 시간"
    case royalJelly = "로얄젤리"
    case memberList = "전체 꿀벌"
    
    case logout = "로그아웃"
    case leaveBee = "모임 떠나기"
}

struct SettingContent {
    let title: SettingContentTitle
    let detail: String
    let isQueenBee: Bool
    let isPushToOther: Bool
}
