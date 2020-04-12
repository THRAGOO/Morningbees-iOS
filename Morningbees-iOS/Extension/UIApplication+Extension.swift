//
//  UIApplication+Extension.swift
//  Morningbees-iOS
//
//  Created by junlee on 28/11/2019.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var keyWindow: UIWindow? {
        for window in windows {
            if window.isKeyWindow {
                return window
            }
        }
        return nil
    }
}
