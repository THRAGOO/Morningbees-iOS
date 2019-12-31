//
//  Logger.swift
//  Morningbees-iOS
//
//  Created by JUN LEE on 2019/12/17.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import SwiftyBeaver

struct Logger {
    static let shared = Logger()

    let log = SwiftyBeaver.self

    init() {
        log.addDestination(ConsoleDestination())
    }

    static func debug(_ message: String) {
        Logger.shared.log.debug(message)
    }
}
