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

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //MARK: Swizzle

        UIViewController.swizzle

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

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        GIDSignIn.sharedInstance().handle(url)

        return true
    }

    //MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
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

        //TODO: We have to manage the storyboard separately. (Enum)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
            let signInViewController = navigationController.topViewController as? SignInViewController,
            let signUpViewController = mainStoryboard.instantiateViewController(
                withIdentifier: "\(SignUpViewController.self)") as? SignUpViewController else {
                    fatalError("Not found the SignUpViewController")
        }

        signInViewController.navigationController?.pushViewController(signUpViewController, animated: true)
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("[Error] :", error.localizedDescription)
            return
        }
        print("[Success] : Disconnect with Google")

        guard let navigationController =
            UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
                fatalError("Not found the navigationController")
        }

        navigationController.popViewController(animated: true)
    }
}
