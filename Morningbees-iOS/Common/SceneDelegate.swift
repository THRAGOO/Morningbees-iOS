//
//  SceneDelegate.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/11/03.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import NaverThirdPartyLogin
import FirebaseDynamicLinks

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let userActivity = connectionOptions.userActivities.first,
              let incomingURL = userActivity.webpageURL else {
            return
        }
        DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let dynamicLink = dynamicLink {
                self.handleDynamicLinks(dynamicLink)
            }
        }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let incomingURL = userActivity.webpageURL else {
            return
        }
        DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let dynamicLink = dynamicLink {
                self.handleDynamicLinks(dynamicLink)
            }
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        NaverThirdPartyLoginConnection.getSharedInstance()?.receiveAccessToken(URLContexts.first?.url)
    }
}

// MARK:- DynamicLink Handling

extension SceneDelegate {
    
    private func handleDynamicLinks(_ dynamiclink: DynamicLink) {
        if (GIDSignIn.sharedInstance()?.currentUser) != nil ||
            NaverThirdPartyLoginConnection.getSharedInstance()?.accessToken != nil {
            guard let url = dynamiclink.url else {
                return
            }
            if UserDefaults.standard.bool(forKey: UserDefaultsKey.alreadyJoin.rawValue) {
                print("Already Joined another Bee!")
            } else {
                guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                    let queryItems = components.queryItems else {
                        return
                }
                for queryItem in queryItems {
                    let value = queryItem.value?.replacingOccurrences(of: "+", with: " ")
                    UserDefaults.standard.set(value ?? "", forKey: queryItem.name)
                }
                NavigationControl.pushToInvitedViewController()
            }
        }
    }
}
