//
//  SignUpViewController.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/11/22.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import Firebase
import GoogleSignIn
import NaverThirdPartyLogin
import UIKit

final class SignUpViewController: UIViewController {

//MARK:- Properties

    private let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance()

//MARK:- Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

//MARK:- Navigation Control

extension SignUpViewController {

    private func popToSignInViewContoller() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK:- SignOut Naver

extension SignUpViewController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    }

    func oauth20ConnectionDidFinishDeleteToken() {
        print("[Success] : Disconnect with Naver")
        popToSignInViewContoller()
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }

    //MARK: Action

    @IBAction private func touchUpSignOutNaver(_ sender: UIButton) {
        naverSignInInstance?.delegate = self
        naverSignInInstance?.resetToken()
        popToSignInViewContoller()
    }

    @IBAction private func touchUpDisconnectNaver(_ sender: UIButton) {
        naverSignInInstance?.delegate = self
        naverSignInInstance?.requestDeleteToken()
    }
}

//MARK:- SignOut Google

extension SignUpViewController {

    //MARK: Action

    @IBAction private func touchUpSignOutGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        popToSignInViewContoller()
    }

    @IBAction private func touchUpDisconnectGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.disconnect()
    }
}

//MARK:- Touch Gesture Handling

extension SignUpViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
