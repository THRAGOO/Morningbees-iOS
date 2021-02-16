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

        // MARK: SetUp for SignIn with Naver

        if let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance() {
            naverSignInInstance.isInAppOauthEnable = true
            naverSignInInstance.isNaverAppOauthEnable = false
            naverSignInInstance.setOnlyPortraitSupportInIphone(true)
            naverSignInInstance.serviceUrlScheme = kServiceAppUrlScheme
            naverSignInInstance.consumerKey = kConsumerKey
            naverSignInInstance.consumerSecret = kConsumerSecret
            naverSignInInstance.appName = kServiceAppName
        }

        // MARK: SetUp for SignIn with Google

        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
}

// MARK:- Google SignIn

extension AppDelegate: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
        print("[Error] :", error.localizedDescription)
            return
        }

        // TODO: We have to manage the storyboard separately. (Enum)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
            let signInViewController = navigationController.topViewController as? SignInViewController,
            let signUpViewController = mainStoryboard.instantiateViewController(
                withIdentifier: "\(SignUpViewController.self)") as? SignUpViewController,
            let beeViewController = mainStoryboard.instantiateViewController(
                withIdentifier: "\(BeeMainViewController.self)") as? BeeMainViewController,
            let beforeJoinViewController = mainStoryboard.instantiateViewController(
                withIdentifier: "\(BeforeJoinViewController.self)") as? BeforeJoinViewController else {
                    fatalError("Not found the SignUpViewController")
        }
        
        signInViewController.activityIndicator.startAnimating()
        guard let accessToken = user.authentication.idToken else {
            signInViewController.activityIndicator.stopAnimating()
            signInViewController.presentConfirmAlert(title: "구글 토큰 에러!", message: "구글 토큰을 성공적으로 받아오지 못했습니다.")
            return
        }
        let requestModel = SignInModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let param: [String: String] = ["socialAccessToken": accessToken,
                                       "provider": SignInProvider.google.rawValue]
        let signInRequest = Request<SignIn>()
        signInRequest.request(request: request, parameter: param) { (signIn, _, error)  in
            if let error = error {
                DispatchQueue.main.async {
                    signInViewController.activityIndicator.stopAnimating()
                }
                signInViewController.presentConfirmAlert(title: "구글 로그인 에러!", message: error.localizedDescription)
            }
            guard let signIn = signIn else {
                DispatchQueue.main.async {
                    signInViewController.activityIndicator.stopAnimating()
                }
                signInViewController.presentConfirmAlert(title: "구글 로그인 에러!", message: "")
                return
            }
            if signIn.type == 0 {
                DispatchQueue.main.async {
                    signInViewController.activityIndicator.stopAnimating()
                    signUpViewController.provider = .google
                    signInViewController.navigationController?.pushViewController(signUpViewController,
                                                                                  animated: true)
                }
            } else if signIn.type == 1 {
                KeychainService.deleteKeychainToken { (error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            signInViewController.activityIndicator.stopAnimating()
                        }
                        signInViewController.presentConfirmAlert(title: "키체인 에러!", message: error.localizedDescription)
                    }
                }
                KeychainService.addKeychainToken(signIn.accessToken, signIn.refreshToken) { (error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            signInViewController.activityIndicator.stopAnimating()
                        }
                        signInViewController.presentConfirmAlert(title: "키체인 에러!", message: error.localizedDescription)
                    }
                }
                MeAPI().request { (alreadyJoinedBee, error) in
                    DispatchQueue.main.async {
                        signInViewController.activityIndicator.stopAnimating()
                    }
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    guard let alreadyJoinedBee = alreadyJoinedBee else {
                        return
                    }
                    if alreadyJoinedBee {
                        DispatchQueue.main.async {
                            signInViewController.navigationController?.pushViewController(beeViewController,
                                                                                          animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            signInViewController.navigationController?.pushViewController(beforeJoinViewController,
                                                                                          animated: true)
                        }
                    }
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
            signUpViewController.presentConfirmAlert(title: "구글 로그아웃 에러!", message: error.localizedDescription)
            return
        }
        navigationController.popToRootViewController(animated: true)
    }
}
