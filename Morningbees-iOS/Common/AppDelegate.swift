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

        //TODO: We have to manage the storyboard separately. (Enum)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
            let signInViewController = navigationController.topViewController as? SignInViewController,
            let signUpViewController = mainStoryboard.instantiateViewController(
                withIdentifier: "\(SignUpViewController.self)") as? SignUpViewController,
            let beeViewController = mainStoryboard.instantiateViewController(
                withIdentifier: "\(BeeViewController.self)") as? BeeViewController else {
                    fatalError("Not found the SignUpViewController")
        }
        
        guard let accessToken = user.authentication.idToken else {
            signInViewController.presentOneBtnAlert(title: "Error!", message: "Couldn't get accessToken.")
            return
        }
        let reqModel = SignInModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let param: [String: String] = [
            "socialAccessToken": accessToken,
            "provider": SignInProvider.google.rawValue
        ]
        let signInReq = Request<SignIn>()
        signInReq.request(req: request, header: nil, param: param) { (signIn, error)  in
            if let error = error {
                signInViewController.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
            }
            guard let signIn = signIn else {
                return
            }
            if signIn.type == 0 {
                DispatchQueue.main.async {
                    signUpViewController.provider = SignInProvider.google.rawValue
                    signInViewController.navigationController?.pushViewController(signUpViewController,
                                                                                  animated: true)
                }
            } else if signIn.type == 1 {
                
                //MARK: KeyChain
                    
                KeychainService.deleteKeychainToken { (error) in
                    if let error = error {
                        signInViewController.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
                    }
                }
                KeychainService.addKeychainToken(signIn.accessToken, signIn.refreshToken) { (error) in
                    if let error = error {
                        signInViewController.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
                    }
                }
                DispatchQueue.main.async {
                    signInViewController.navigationController?.pushViewController(beeViewController, animated: true)
                }
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
            let signUpViewController = mainStoryboard.instantiateViewController(
                withIdentifier: "\(SignUpViewController.self)") as? SignUpViewController else {
                    fatalError("Not found the SignUpViewController")
        }
        if let error = error {
            signUpViewController.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
            return
        }
        navigationController.popToRootViewController(animated: true)
    }
}
