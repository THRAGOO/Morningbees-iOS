//
//  AppDelegate.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/11/03.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import Firebase
import GoogleSignIn
import NaverThirdPartyLogin
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        GIDSignIn.sharedInstance().handle(url)
        return true
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: Swizzle
        
        UIViewController.swizzle
        
        // MARK: Notification Badge
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        // MARK: Set up for SignIn with Naver
        
        if let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance() {
            naverSignInInstance.isInAppOauthEnable = true
            naverSignInInstance.isNaverAppOauthEnable = true
            naverSignInInstance.setOnlyPortraitSupportInIphone(true)
            naverSignInInstance.serviceUrlScheme = kServiceAppUrlScheme
            naverSignInInstance.consumerKey = kConsumerKey
            naverSignInInstance.consumerSecret = kConsumerSecret
            naverSignInInstance.appName = kServiceAppName
        }
        
        // MARK: Set up for SignIn with Google
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
}

// MARK:- Google SignIn

extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
              let signInViewController = navigationController.topViewController as? SignInViewController else {
            fatalError()
        }
        if let _ = error {
            return
        }
        guard let googleToken = user.authentication.idToken else {
            signInViewController.presentConfirmAlert(title: "구글 토큰 에러!", message: "구글 토큰을 성공적으로 받아오지 못했습니다.")
            return
        }
        signInViewController.requestSocialSignIn(from: .google, with: googleToken)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
}
