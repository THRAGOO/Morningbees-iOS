//
//  ViewController.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/11/03.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import Firebase
import GoogleSignIn
import NaverThirdPartyLogin
import UIKit

final class SignInViewController: UIViewController {

//MARK:- Properties

    private let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    var accessToken = ""
    var refreshToken = ""

//MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

//MARK:- Navigation Control

extension SignInViewController {

    private func pushToSignUpViewController() {
        DispatchQueue.main.async {
            guard let signUpViewController = self.storyboard?.instantiateViewController(
                identifier: "SignUpViewController") as? SignUpViewController else {
                    fatalError("Missing ViewController")
            }
            self.navigationController?.pushViewController(signUpViewController, animated: true)
        }
    }
}

//MARK:- SignIn with Naver

extension SignInViewController: NaverThirdPartyLoginConnectionDelegate {

    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        naverSignInRequest()
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        naverSignInRequest()
    }
    
    func naverSignInRequest() {
        let accessToken = naverSignInInstance?.accessToken
        print(accessToken ?? "nil")
        let reqModel = SignInModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let param: [String: String?] = [
            "socialAccessToken": accessToken,
            "provider": "naver"
        ]
        let signInReq = Request<SignIn>()
        signInReq.request(req: request, param: param) { (signIn, error)  in
            if let error = error {
                self.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
            }
            guard let signIn = signIn else {
                return
            }
            if signIn.type == 0 {
                self.pushToSignUpViewController()
            } else if signIn.type == 1 {
                if self.accessToken == signIn.accessToken
                    || self.refreshToken == signIn.refreshToken {
                    // move to main view.
                }
            } else {
                self.presentOneBtnAlert(title: "Error!", message: "Invalid Value.")
            }
            return
        }
    }

    func oauth20ConnectionDidFinishDeleteToken() {
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }

    //MARK: Action

    @IBAction private func touchUpSignInNaver(_ sender: UIButton) {
        naverSignInInstance?.delegate = self
        naverSignInInstance?.requestThirdPartyLogin()
    }
}

//MARK:- SignIn with Google

extension SignInViewController: CustomAlert {

    //MARK: Action

    @IBAction private func touchUpSignInGoogle(_ sender: UIButton) {
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        } else {
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
}
