//
//  ViewController.swift
//  Morningbees-iOS
//
//  Created by JUN LEE on 2019/11/03.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import Firebase
import GoogleSignIn
import NaverThirdPartyLogin
import UIKit

class SignInViewController: UIViewController {
    
//MARK:- Properties
    
    private let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
//MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        (UIApplication.shared.delegate as? AppDelegate)?.signInCallBack = pushToSignUpViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

//MARK:- Navigation Control

extension SignInViewController {
    
    func pushToSignUpViewController() {
        let signUpViewInstance = self.storyboard?.instantiateViewController(identifier: "SignUp")
        self.navigationController?.pushViewController(signUpViewInstance!, animated: true)
    }
}

//MARK:- SignIn with Naver

extension SignInViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("[Success] : SignIn with Naver")
        pushToSignUpViewController()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("[Success] : refresh token")
        pushToSignUpViewController()
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }
    
    //MARK: Action
    
    @IBAction func touchUpSignInNaver(_ sender: UIButton) {
        naverSignInInstance?.delegate = self
        naverSignInInstance?.requestThirdPartyLogin()
    }
}

//MARK:- SignIn with Google

extension SignInViewController {
    
    //MARK: Action
    
    @IBAction func touchUpSignInGoogle(_ sender: UIButton) {
        if ((GIDSignIn.sharedInstance()?.hasPreviousSignIn())!) {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        } else {
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
}
