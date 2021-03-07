//
//  ServerError.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/12/31.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import Foundation

struct ServerError: Decodable {
    let timestamp: String
    let status: Int
    let message: String
    let code: Int
}
