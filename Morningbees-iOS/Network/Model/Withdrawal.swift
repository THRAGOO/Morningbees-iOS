//
//  Withdrawal.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/11/11.
//  Copyright © 2020 THRAGOO. All rights reserved.
//

import Foundation

struct WithdrawalModel: RequestModel {
    typealias ModelType = Withdrawal
    var method: HTTPMethod = .delete
    var path: Path = .beeWithdrawal
}

struct Withdrawal: Codable {
}
