//
//  ViewController.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/11/03.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import AuthenticationServices
import Firebase
import GoogleSignIn
import NaverThirdPartyLogin
import UIKit

final class SignInViewController: UIViewController {

//MARK:- Properties

    private let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance()

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

    private func pushToSignUpViewController(from provider: SignInProvider) {
        DispatchQueue.main.async {
            guard let signUpViewController = self.storyboard?.instantiateViewController(
                identifier: "SignUpViewController") as? SignUpViewController else {
                    print(String(describing: SignUpViewController.self))
                    return
            }
            signUpViewController.provider = provider.rawValue
            self.navigationController?.pushViewController(signUpViewController, animated: true)
        }
    }
    
    private func pushToBeeViewController() {
        DispatchQueue.main.async {
            guard let beeViewController = self.storyboard?.instantiateViewController(
                identifier: "BeeViewController") as? BeeViewController else {
                    print(String(describing: BeeViewController.self))
                    return
            }
            self.navigationController?.pushViewController(beeViewController, animated: true)
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
        guard let accessToken = naverSignInInstance?.accessToken else {
            self.presentOneBtnAlert(title: "Error!", message: "")
            return
        }
        let reqModel = SignInModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let param: [String: String] = ["socialAccessToken": accessToken,
                                       "provider": SignInProvider.naver.rawValue]
        let signInReq = Request<SignIn>()
        signInReq.request(req: request, param: param) { (signIn, error)  in
            if let error = error {
                self.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
            }
            guard let signIn = signIn else {
                return
            }
            if signIn.type == 0 {
                self.pushToSignUpViewController(from: .naver)
            } else if signIn.type == 1 {
                
                //MARK: KeyChain
                
                KeychainService.deleteKeychainToken { (error) in
                    if let error = error {
                        self.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
                    }
                }
                KeychainService.addKeychainToken(signIn.accessToken, signIn.refreshToken) { (error) in
                    if let error = error {
                        self.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
                    }
                }
                self.pushToBeeViewController()
            } else {
                self.presentOneBtnAlert(title: "Error!", message: "Invalid Value(Type).")
            }
        }
    }

    func oauth20ConnectionDidFinishDeleteToken() {
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
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

//MARK:- SignIn with Apple

extension SignInViewController: ASAuthorizationControllerDelegate {
    
    //MARK: TouchUp SignIn with Apple Action
    
    @IBAction private func touchUpSignInApple(_ sender: UIButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let identityToken = appleIDCredential.identityToken else {
                self.presentOneBtnAlert(title: "Error!", message: "Couldn't get Apple information")
                return
            }
            let userID = appleIDCredential.user
            let appleToken = String(decoding: identityToken, as: UTF8.self)
            appleSignInRequest(userID, appleToken)
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        presentOneBtnAlert(title: "Alert", message: "The process has been canceled.")
    }
    
    func appleSignInRequest(_ userID: String, _ accessToken: String) {
        let reqModel = SignInModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let param: [String: String] = ["socialAccessToken": accessToken,
                                       "provider": SignInProvider.apple.rawValue]
        let signInReq = Request<SignIn>()
        signInReq.request(req: request, param: param) { (signIn, error)  in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let signIn = signIn else {
                return
            }
            
            //MARK: KeyChain
            
            KeychainService.deleteKeychainAppleInfo { (error) in
                if let error = error {
                    self.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
                }
            }
            KeychainService.addKeychainAppleInfo(userID, accessToken) { (error) in
                if let error = error {
                    self.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
                }
            }
            
            if signIn.type == 0 {
                self.pushToSignUpViewController(from: .apple)
            } else if signIn.type == 1 {
                self.pushToBeeViewController()
            } else {
                self.presentOneBtnAlert(title: "Error!", message: "Invalid Value(Type).")
            }
        }
    }
}

//MARK:- Provide Presentation Anchor

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let presentView = self.view.window else {
            fatalError("Not found the SignIn View")
        }
        return presentView
    }
}
