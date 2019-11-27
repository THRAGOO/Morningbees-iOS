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
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var signInCallBack: (() -> ())?
    var disconnectCallBack: (() -> ())?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //MARK: SetUp for SignIn with Naver
        
        if let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance() {
            naverSignInInstance.isInAppOauthEnable = true
            naverSignInInstance.isNaverAppOauthEnable = false
            naverSignInInstance.setOnlyPortraitSupportInIphone(true)
            naverSignInInstance.serviceUrlScheme = kServiceAppUrlScheme
            naverSignInInstance.consumerKey = kConsumerKey
            naverSignInInstance.consumerSecret = kConsumerSecret
            naverSignInInstance.appName = kServiceAppName
        }
        
        //MARK: SetUp for SignIn with Google
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        GIDSignIn.sharedInstance().handle(url)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

//MARK:- Google SignIn

extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
        print("[Error] :", error.localizedDescription)
            return
        }
        print("[Success] : SignIn with Google")
        signInCallBack!()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("[Error] :", error.localizedDescription)
            return
        }
        print("[Success] : Disconnect with Google")
        disconnectCallBack!()
    }
}

