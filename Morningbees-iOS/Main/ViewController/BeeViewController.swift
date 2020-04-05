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
    
    @IBAction private func touchUpRenewalBtn(_ sender: UIButton) {
        RenewalToken().request { (error) in
            if let error = error {
                self.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
            }
        }
        KeychainService.extractKeyChainToken { (accessToken, refreshToken, error) in
            if let error = error {
                self.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
            }
            self.accessTokenTextView.text = accessToken
            self.refreshTokenTextView.text = refreshToken
        }
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
                    self.pushToBeforeJoinViewController()
                }
            }
        }
    }
}

//MARK:- Navigation Control

extension BeeViewController {

    private func popToSignInViewContoller() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func pushToBeforeJoinViewController() {
        DispatchQueue.main.async {
            guard let beforeJoinViewController = self.storyboard?.instantiateViewController(
                identifier: "BeforeJoinViewController") as? BeforeJoinViewController else {
                    print(String(describing: BeforeJoinViewController.self))
                    return
            }
            self.navigationController?.pushViewController(beforeJoinViewController, animated: true)
        }
    }
}
