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
    static var navigationController: UINavigationController {
        guard let navigationViewController = UIApplication.shared.keyWindow?.rootViewController
                as? UINavigationController else {
            fatalError()
        }
        return navigationViewController
    }
}

extension NavigationControl {
    
    static func popToRootViewController() {
        DispatchQueue.main.async {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    static func popViewController() {
        DispatchQueue.main.async {
            navigationController.popViewController(animated: true)
        }
    }
    
    static func pushToSignInViewController() {
        DispatchQueue.main.async {
            navigationController.pushViewController(SignInViewController(), animated: false)
        }
    }
    
    static func pushToSignUpViewController(from provider: SignInProvider, with socialAccessToken: String) {
        let signUpViewController = SignUpViewController()
        signUpViewController.provider = provider
        signUpViewController.socialAccessToken = socialAccessToken
        navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    static func pushToBeforeJoinViewController() {
        DispatchQueue.main.async {
            navigationController.pushViewController(BeforeJoinViewController(), animated: false)
        }
    }
    
    static func pushToBeeCreateViewController() {
        DispatchQueue.main.async {
            navigationController.pushViewController(BeeCreateNameViewController(), animated: true)
        }
    }
    
    static func pushToBeeMainViewController() {
        DispatchQueue.main.async {
            navigationController.pushViewController(BeeMainViewController(), animated: false)
        }
    }
    
    static func pushToInvitedViewController() {
        DispatchQueue.main.async {
            navigationController.pushViewController(InvitedViewController(), animated: true)
        }
    }
    
    static func pushToMissionCreateViewController() {
        DispatchQueue.main.async {
            navigationController.pushViewController(MissionCreateViewController(), animated: true)
        }
    }
    
    static func pushToPreviewMissionViewController() {
        DispatchQueue.main.async {
            navigationController.pushViewController(PreviewMissionViewController(), animated: true)
        }
    }
    
    static func pushToMissionListViewController() {
        DispatchQueue.main.async {
            navigationController.pushViewController(MissionListViewController(), animated: true)
        }
    }
    
    static func pushToSettingViewController() {
        DispatchQueue.main.async {
            navigationController.pushViewController(SettingViewController(), animated: true)
        }
    }
    
    static func pushToMemberViewController() {
        DispatchQueue.main.async {
            navigationController.pushViewController(MemberViewController(), animated: true)
        }
    }
    
    static func pushToRoyalJellyViewController() {
        DispatchQueue.main.async {
            navigationController.pushViewController(RoyalJellyViewController(), animated: true)
        }
    }
}
