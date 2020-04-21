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
    
    func pushToBeeViewController() {
        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            guard let beeViewController = self.mainStoryboard.instantiateViewController(
                identifier: "BeeViewController") as? BeeViewController else {
                    print(String(describing: BeeViewController.self))
                    return
            }
            navigationController?.pushViewController(beeViewController, animated: true)
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
    
    func pushToBCStepOneViewController() {
        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            guard let bcStepOneViewController = self.mainStoryboard.instantiateViewController(
                identifier: "BeeCreateNameViewController") as? BeeCreateNameViewController else {
                    print(String(describing: BeeCreateNameViewController.self))
                    return
            }
            navigationController?.pushViewController(bcStepOneViewController, animated: true)
        }
    }
}
