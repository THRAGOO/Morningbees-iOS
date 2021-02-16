//
//  NavigationControl.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/12.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class NavigationControl {
    
    static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
}

extension NavigationControl {
    
    static func popToRootViewController() {
        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    static func pushToInvitedViewController() {
        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            guard let invitedViewController = self.mainStoryboard.instantiateViewController(
                identifier: "InvitedViewController") as? InvitedViewController else {
                    print(String(describing: InvitedViewController.self))
                    return
            }
            navigationController?.pushViewController(invitedViewController, animated: true)
        }
    }
}
