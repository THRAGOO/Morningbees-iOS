//
//  NavigationControl.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/12.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class NavigationControl {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
}

extension NavigationControl {
    
    func popToRootViewController() {
        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func popToPrevViewController() {
        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            navigationController?.popViewController(animated: true)
        }
    }
    
    func pushToSignUpViewController(from provider: SignInProvider) {
        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            guard let signUpViewController = self.mainStoryboard.instantiateViewController(
                identifier: "SignUpViewController") as? SignUpViewController else {
                    print(String(describing: SignUpViewController.self))
                    return
            }
            signUpViewController.provider = provider.rawValue
            navigationController?.pushViewController(signUpViewController, animated: true)
        }
    }
    
    func pushToBeeMainViewController() {
        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            guard let beeMainViewController = self.mainStoryboard.instantiateViewController(
                identifier: "BeeMainViewController") as? BeeMainViewController else {
                    print(String(describing: BeeMainViewController.self))
                    return
            }
            navigationController?.pushViewController(beeMainViewController, animated: true)
        }
    }
    
    func pushToBeforeJoinViewController() {
        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            guard let beforeJoinViewController = self.mainStoryboard.instantiateViewController(
                identifier: "BeforeJoinViewController") as? BeforeJoinViewController else {
                    print(String(describing: BeforeJoinViewController.self))
                    return
            }
            navigationController?.pushViewController(beforeJoinViewController, animated: true)
        }
    }
    
    func pushToBeeCreateNameViewController() {
        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            guard let beeCreateNameViewController = self.mainStoryboard.instantiateViewController(
                identifier: "BeeCreateNameViewController") as? BeeCreateNameViewController else {
                    print(String(describing: BeeCreateNameViewController.self))
                    return
            }
            navigationController?.pushViewController(beeCreateNameViewController, animated: true)
        }
    }
    
    func pushToMissionCreateViewController() {
        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            guard let missionCreateViewController = self.mainStoryboard.instantiateViewController(
                identifier: "MissionCreateViewController") as? MissionCreateViewController else {
                    print(String(describing: MissionCreateViewController.self))
                    return
            }
            navigationController?.pushViewController(missionCreateViewController, animated: true)
        }
    }
}
