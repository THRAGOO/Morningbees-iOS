//
//  ServerError.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/12/31.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import Foundation

enum ServerErrAlert: String {
    case title = "Server Error"
}

struct ServerError: Decodable {
    let timestamp: Int
    let status: Int
    let message: String
    let code: Int
}
