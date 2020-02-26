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
import SnapKit
import UIKit

final class SignInViewController: UIViewController {

//MARK:- Properties

    private let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private let backgroundYellowImg = DesignSet.initImageView(imgName: "bgSignin")
    private let backgroundWhiteImg = DesignSet.initImageView(imgName: "bgSignInWhite")
    private let logoTitleImg = DesignSet.initImageView(imgName: "logoTitle")
    private let beeImgSuperView = UIView()
    private let beeImgView = DesignSet.initImageView(imgName: "bee")
    private let appleLogoImg = DesignSet.initImageView(imgName: "appleLogo")
    private let naverLogoImg = DesignSet.initImageView(imgName: "logoNaver")
    private let googleLogoImg = DesignSet.initImageView(imgName: "logoGoogle")
    
    private let subtitleLabel: UILabel = {
        let label = DesignSet.initLabel(text: "친구들과 함께하는 기상미션")
        label.textColor = DesignSet.colorSet(red: 68, green: 68, blue: 68)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let appleSignInTitle: UILabel = {
        let label = DesignSet.initLabel(text: "Apple 계정으로 로그인")
        label.textColor = DesignSet.colorSet(red: 255, green: 255, blue: 255)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let naverSignInTitle: UILabel = {
        let label = DesignSet.initLabel(text: "Naver 계정으로 로그인")
        label.textColor = DesignSet.colorSet(red: 255, green: 255, blue: 255)
        label.font = UIFont(name: TextFonts.naverFont.rawValue, size: 20)
        return label
    }()
    
    private let googleSignInTitle: UILabel = {
        let label = DesignSet.initLabel(text: "Google 계정으로 로그인")
        label.textColor = DesignSet.colorSet(red: 119, green: 119, blue: 119)
        label.font = UIFont(name: TextFonts.googleFont.rawValue, size: 20)
        return label
    }()
    
    private let appleSignInBtn: UIButton = {
       let button = UIButton()
        button.backgroundColor = DesignSet.colorSet(red: 0, green: 0, blue: 0)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(touchUpSignInApple), for: .touchUpInside)
        return button
    }()
    private let naverSignInBtn: UIButton = {
       let button = UIButton()
        button.backgroundColor = DesignSet.colorSet(red: 30, green: 200, blue: 0)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(touchUpSignInNaver), for: .touchUpInside)
        return button
    }()
    private let googleSignInBtn: UIButton = {
       let button = UIButton()
        button.backgroundColor = DesignSet.colorSet(red: 255, green: 255, blue: 255)
        button.layer.borderColor = DesignSet.colorSet(red: 204, green: 204, blue: 204).cgColor
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(touchUpSignInGoogle), for: .touchUpInside)
        return  button
    }()

//MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        self.setupDesign()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.beeImgSuperView.center = CGPoint(x: DesignSet.frameWidth / 2,
                                                  y: (369 / StandardDevice.height.rawValue) * DesignSet.frameHeight)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.beeImgSuperView.snp.makeConstraints {
            $0.top.equalTo((400.9 / StandardDevice.height.rawValue) * DesignSet.frameHeight)
        }
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

    @objc private func touchUpSignInNaver(_ sender: UIButton) {
        naverSignInInstance?.delegate = self
        naverSignInInstance?.requestThirdPartyLogin()
    }
}

//MARK:- SignIn with Google

extension SignInViewController: CustomAlert {

    //MARK: Action

    @objc private func touchUpSignInGoogle(_ sender: UIButton) {
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
    
    @objc private func touchUpSignInApple(_ sender: UIButton) {
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

//MARK:- View Design

extension SignInViewController {
    
    private func setupDesign() {
        
        self.view.addSubview(backgroundYellowImg)
        self.view.addSubview(backgroundWhiteImg)
        self.view.addSubview(logoTitleImg)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(beeImgSuperView)
        beeImgSuperView.addSubview(beeImgView)
        self.view.addSubview(appleSignInBtn)
        appleSignInBtn.addSubview(appleLogoImg)
        appleSignInBtn.addSubview(appleSignInTitle)
        self.view.addSubview(naverSignInBtn)
        naverSignInBtn.addSubview(naverLogoImg)
        naverSignInBtn.addSubview(naverSignInTitle)
        self.view.addSubview(googleSignInBtn)
        googleSignInBtn.addSubview(googleLogoImg)
        googleSignInBtn.addSubview(googleSignInTitle)
        
        backgroundYellowImg.layer.zPosition = 0
        logoTitleImg.layer.zPosition = 1
        subtitleLabel.layer.zPosition = 1
        beeImgSuperView.layer.zPosition = 1
        backgroundWhiteImg.layer.zPosition = 2
        appleSignInBtn.layer.zPosition = 3
        naverSignInBtn.layer.zPosition = 3
        googleSignInBtn.layer.zPosition = 3
        
        DesignSet.constraints(view: backgroundYellowImg, top: 0, leading: 0, height: 462, width: 375)
        DesignSet.constraints(view: backgroundWhiteImg, top: 387, leading: 0, height: 280, width: 375)
        
        DesignSet.constraints(view: logoTitleImg, top: 148, leading: 89, height: 69, width: 198)
        DesignSet.constraints(view: subtitleLabel, top: 114, leading: 99, height: 22, width: 177)
        
        DesignSet.constraints(view: beeImgSuperView, top: 400.9, leading: 102, height: 188, width: 172)
        DesignSet.constraints(view: beeImgView, top: 0, leading: 0, height: 188, width: 172)
        
        DesignSet.constraints(view: appleSignInBtn, top: 484, leading: 24, height: 45, width: 327)
        DesignSet.constraints(view: appleLogoImg, top: 12, leading: 82, height: 19, width: 16)
        DesignSet.constraints(view: appleSignInTitle, top: 14, leading: 120, height: 17, width: 126)
        
        DesignSet.constraints(view: naverSignInBtn, top: 541, leading: 24, height: 45, width: 327)
        DesignSet.constraints(view: naverLogoImg, top: 15, leading: 80, height: 16, width: 18)
        DesignSet.constraints(view: naverSignInTitle, top: 15, leading: 118, height: 16, width: 128)
        
        DesignSet.constraints(view: googleSignInBtn, top: 598, leading: 24, height: 45, width: 327)
        DesignSet.constraints(view: googleLogoImg, top: 4, leading: 67.5, height: 37, width: 37)
        DesignSet.constraints(view: googleSignInTitle, top: 14, leading: 116, height: 17, width: 134)
    }
}
