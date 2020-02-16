//
//  BeeViewController.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2020/02/15.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit
import GoogleSignIn
import NaverThirdPartyLogin

class BeeViewController: UIViewController {
    
//MARK:- Properties
    
    private let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    @IBOutlet private weak var accessTokenTextView: UITextView!
    @IBOutlet private weak var refreshTokenTextView: UITextView!
    
//MARK:- Life Cycle
    
    override func viewDidLoad() {
        extractToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

//MARK:- SignOut Naver

extension BeeViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    }

    func oauth20ConnectionDidFinishDeleteToken() {
        popToSignInViewContoller()
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
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

extension BeeViewController {

    //MARK: Action

    @IBAction private func touchUpSignOutGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        popToSignInViewContoller()
    }

    @IBAction private func touchUpDisconnectGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.disconnect()
    }
}

//MARK:- Navigation Control

extension BeeViewController {

    private func popToSignInViewContoller() {
//        navigationController?.popViewController(animated: false)
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK:- Testing Extract Token

extension BeeViewController: CustomAlert {
    
    func extractToken() {
        let tokenQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: Path.base.rawValue,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var tokenItem: CFTypeRef?
        let matchStatus = SecItemCopyMatching(tokenQuery as CFDictionary, &tokenItem)
        guard matchStatus != errSecItemNotFound else {
            presentOneBtnAlert(title: "Error!", message: KeychainError.noToken.localizedDescription)
            return
        }
        guard matchStatus == errSecSuccess else {
            presentOneBtnAlert(title: "Error!",
                               message: KeychainError.unhandledError(status: matchStatus).localizedDescription)
            return
        }
        guard let existingItem = tokenItem as? [String: Any],
            let accessTokenData = existingItem[kSecValueData as String] as? Data,
            let accessToken = String(data: accessTokenData, encoding: String.Encoding.utf8),
            let refreshTokenData = existingItem[kSecAttrAccount as String] as? Data,
            let refreshToken = String(data: refreshTokenData, encoding: String.Encoding.utf8)
        else {
            presentOneBtnAlert(title: "Error!", message: KeychainError.unexpectedTokenData.localizedDescription)
            return
        }
        let credentials = Credentials(accessToken: accessToken, refreshToken: refreshToken)
        self.accessTokenTextView.text = credentials.accessToken
        self.refreshTokenTextView.text = credentials.refreshToken
    }
}
