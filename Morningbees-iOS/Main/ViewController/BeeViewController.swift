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

final class BeeViewController: UIViewController, CustomAlert {
    
//MARK:- Properties
    
    private let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    @IBOutlet private weak var accessTokenTextView: UITextView!
    @IBOutlet private weak var refreshTokenTextView: UITextView!
    @IBOutlet private weak var renewalBtn: UIButton!
    
//MARK:- Life Cycle
    
    override func viewDidLoad() {
        KeychainService.extractKeyChainToken { (accessToken, refreshToken, error) in
            if let error = error {
                self.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
            }
            self.accessTokenTextView.text = accessToken
            self.refreshTokenTextView.text = refreshToken
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK:- SignOut Naver

extension BeeViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    }

    func oauth20ConnectionDidFinishDeleteToken() {
        NavigationControl().popToRootViewController()
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
    }

    //MARK: Action

    @IBAction private func touchUpSignOutNaver(_ sender: UIButton) {
        naverSignInInstance?.delegate = self
        naverSignInInstance?.resetToken()
        NavigationControl().popToRootViewController()
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
        NavigationControl().popToRootViewController()
    }

    @IBAction private func touchUpDisconnectGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.disconnect()
    }
    
    @IBAction private func touchUpMeRequestBtn(_ sender: UIButton) {
        MeAPI().request { (alreadyJoinedBee, error) in
                if let error = error {
                    self.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
                }
                guard let alreadyJoinedBee = alreadyJoinedBee else {
                    return
                }
                if alreadyJoinedBee {
                    self.presentOneBtnAlert(title: "Already Joined Bee", message: "HAHA~!")
                } else {
                DispatchQueue.main.async {
                    NavigationControl().pushToBeforeJoinViewController()
                }
            }
        }
    }
}
