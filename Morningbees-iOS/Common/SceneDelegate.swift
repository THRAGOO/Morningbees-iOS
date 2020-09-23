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

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

//MARK:- DynamicLink Handling

extension SceneDelegate {
    
    private func handleDynamicLinks(_ dynamiclink: DynamicLink) {
        
        // login control needed
        
        guard let url = dynamiclink.url else {
            return
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems else {
                return
        }
        for queryItem in queryItems {
            UserDefaults.standard.set(queryItem.value ?? "", forKey: queryItem.name)
        }
        NavigationControl().pushToInvitedViewController()
    }
}
