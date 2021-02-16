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
    
    // MARK:- Properties
    
    private let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    public var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.style = .large
        indicator.backgroundColor = .black
        indicator.alpha = 0.5
        return indicator
    }()
    public let activityIndicatorImageView = UIImageView(imageName: "illustErrorPage")
    public let activityIndicatorDescriptionLabel: UILabel = {
        let label = UILabel(text: "로그인 중...", letterSpacing: 0)
        label.textColor = .white
        label.font = UIFont(font: .systemBold, size: 24)
        return label
    }()
    
    private let backgroundYellowImage = UIImageView(imageName: "bgSigninYellow")
    private let backgroundWhiteImage = UIImageView(imageName: "bgSignInWhite")
    private let logoTitleImage = UIImageView(imageName: "logoTitle")
    private let beeImageView = UIImageView(imageName: "bee")
    
    private let subtitleLabel: UILabel = {
        let label = UILabel(text: "친구들과 함께하는 기상미션", letterSpacing: -0.2)
        label.textColor = UIColor(red: 68, green: 68, blue: 68)
        label.font = UIFont(font: .systemBold, size: 16)
        return label
    }()
    
    private let appleSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logoApple"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.setTitle("Apple 계정으로 로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 14)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.setBackgroundColor(.black, for: .normal)
        button.setRatioCornerRadius(4)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(touchUpSignInApple), for: .touchUpInside)
        return button
    }()
    private let naverSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logoNaver"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.setTitle("Naver 계정으로 로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 14)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.setBackgroundColor(UIColor(red: 30, green: 200, blue: 0), for: .normal)
        button.setRatioCornerRadius(4)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(touchUpSignInNaver), for: .touchUpInside)
        return button
    }()
    private let googleSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logoGoogle"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.setTitle("Google 계정으로 로그인", for: .normal)
        button.setTitleColor(UIColor(red: 119, green: 119, blue: 119), for: .normal)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 14)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        button.setBackgroundColor(.white, for: .normal)
        button.setRatioCornerRadius(4)
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor(red: 204, green: 204, blue: 204).cgColor
        button.addTarget(self, action: #selector(touchUpSignInGoogle), for: .touchUpInside)
        return  button
    }()
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        naverSignInInstance?.delegate = self
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        autoSignIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let y = CGFloat(-126 * DesignSet.frameHeightRatio)
        UIView.animate(withDuration: 0.5) {
            self.beeImageView.transform = CGAffineTransform(translationX: 0, y: y)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        beeImageView.transform = .identity
    }
    
    /// Auto SignIn
    private func autoSignIn() {
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        } else if naverSignInInstance?.isValidAccessTokenExpireTimeNow() ?? false {
            naverSignInInstance?.requestThirdPartyLogin()
        }
    }
}

// MARK:- Navigation

extension SignInViewController {
    
    private func pushToSignUpViewController(from provider: SignInProvider) {
        let signUpViewController = SignUpViewController()
        signUpViewController.provider = provider
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
}

// MARK:- SignIn with Naver

extension SignInViewController: NaverThirdPartyLoginConnectionDelegate {
    
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    }
    
    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        requestNaverSignIn()
    }
    
    public func oauth20ConnectionDidFinishDeleteToken() {
    }
    
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        presentConfirmAlert(title: "네이버 로그인 에러!", message: error.localizedDescription)
    }
    
    @objc private func touchUpSignInNaver(_ sender: UIButton) {
        naverSignInInstance?.requestThirdPartyLogin()
    }
    
    private func requestNaverSignIn() {
        activityIndicator.startAnimating()
        guard let accessToken = naverSignInInstance?.accessToken else {
            activityIndicator.stopAnimating()
            presentConfirmAlert(title: "네이버 토큰 에러!", message: "토큰을 성공적으로 받지 못하였습니다.")
            return
        }
        let requestModel = SignInModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let parameter: [String: String] = ["socialAccessToken": accessToken,
                                           "provider": SignInProvider.naver.rawValue]
        let signInReq = Request<SignIn>()
        signInReq.request(request: request, parameter: parameter) { [self] (signIn, _, error)  in
            if let error = error {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "네이버 로그인 에러!", message: error.localizedDescription)
            }
            guard let signIn = signIn else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "네이버 로그인 에러!", message: "")
                return
            }
            if signIn.type == 0 {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    pushToSignUpViewController(from: .naver)
                }
            } else if signIn.type == 1 {
                KeychainService.deleteKeychainToken { (error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            activityIndicator.stopAnimating()
                        }
                        presentConfirmAlert(title: "키체인 토큰 에러!", message: error.localizedDescription)
                    }
                }
                KeychainService.addKeychainToken(signIn.accessToken, signIn.refreshToken) { (error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            activityIndicator.stopAnimating()
                        }
                        presentConfirmAlert(title: "키체인 토큰 에러!", message: error.localizedDescription)
                    }
                }
                MeAPI().request { (alreadyJoinedBee, error) in
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                    }
                    if let error = error {
                        presentConfirmAlert(title: "사용자 정보 요청 에러!", message: error.localizedDescription)
                    }
                    guard let alreadyJoinedBee = alreadyJoinedBee else {
                        presentConfirmAlert(title: "사용자 정보 요청 에러!", message: "")
                        return
                    }
                    if alreadyJoinedBee {
                        DispatchQueue.main.async {
                            navigationController?.pushViewController(BeeMainViewController(), animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            navigationController?.pushViewController(BeforeJoinViewController(), animated: true)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "네이버 로그인 에러!", message: "유효하지 않은 값이 나왔습니다.")
            }
        }
    }
}

// MARK:- SignIn with Google

extension SignInViewController: CustomAlert {
    
    @objc private func touchUpSignInGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
}

// MARK:- SignIn with Apple

extension SignInViewController: ASAuthorizationControllerDelegate {
    
    @objc private func touchUpSignInApple(_ sender: UIButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let identityToken = appleIDCredential.identityToken else {
                presentConfirmAlert(title: "애플 토큰 에러!", message: "애플 토큰을 성공적으로 받아오지 못했습니다.")
                return
            }
            let userID = appleIDCredential.user
            let appleToken = String(decoding: identityToken, as: UTF8.self)
            requestAppleSignIn(userID, appleToken)
        default:
            break
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
    
    private func requestAppleSignIn(_ userID: String, _ accessToken: String) {
        activityIndicator.startAnimating()
        let reqModel = SignInModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let param: [String: String] = ["socialAccessToken": accessToken,
                                       "provider": SignInProvider.apple.rawValue]
        let signInReq = Request<SignIn>()
        signInReq.request(request: request, parameter: param) { [self] (signIn, _, error)  in
            if let error = error {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "애플 로그인 에러!", message: error.localizedDescription)
            }
            guard let signIn = signIn else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "애플 로그인 에러!", message: "")
                return
            }
            KeychainService.deleteKeychainAppleInfo { (error) in
                if let error = error {
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                    }
                    presentConfirmAlert(title: "키체인 토큰 에러!", message: error.localizedDescription)
                }
            }
            KeychainService.addKeychainAppleInfo(userID, accessToken) { (error) in
                if let error = error {
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                    }
                    presentConfirmAlert(title: "키체인 토큰 에러!", message: error.localizedDescription)
                }
            }
            
            if signIn.type == 0 {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    pushToSignUpViewController(from: .apple)
                }
            } else if signIn.type == 1 {
                MeAPI().request { (alreadyJoinedBee, error) in
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                    }
                    if let error = error {
                        presentConfirmAlert(title: "사용자 정보 요청 에러!", message: error.localizedDescription)
                    }
                    guard let alreadyJoinedBee = alreadyJoinedBee else {
                        presentConfirmAlert(title: "사용자 정보 요청 에러!", message: "")
                        return
                    }
                    if alreadyJoinedBee {
                        DispatchQueue.main.async {
                            navigationController?.pushViewController(BeeMainViewController(), animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            navigationController?.pushViewController(BeforeJoinViewController(), animated: true)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "애플 로그인 에러!", message: "유효하지 않은 값이 나왔습니다.")
            }
        }
    }
}

// MARK:- Provide Presentation Anchor

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let presentView = view.window else {
            fatalError("Not found the SignIn View")
        }
        return presentView
    }
}

// MARK:- Layout

extension SignInViewController {
    
    private func setLayout() {
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
        activityIndicator.addSubview(activityIndicatorImageView)
        activityIndicatorImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(activityIndicator.snp.width)
            $0.width.equalToSuperview()
        }
        activityIndicatorImageView.addSubview(activityIndicatorDescriptionLabel)
        activityIndicatorDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(26 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(backgroundYellowImage)
        backgroundYellowImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(482 * DesignSet.frameHeightRatio)
            $0.width.equalToSuperview()
        }
        view.addSubview(backgroundWhiteImage)
        backgroundWhiteImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(367 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(92 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        view.addSubview(logoTitleImage)
        logoTitleImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(124 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(69 * DesignSet.frameHeightRatio)
            $0.width.equalTo(198 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(beeImageView)
        beeImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(380 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(188 * DesignSet.frameHeightRatio)
            $0.width.equalTo(182 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(appleSignInButton)
        appleSignInButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(460 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        view.addSubview(naverSignInButton)
        naverSignInButton.snp.makeConstraints {
            $0.top.equalTo(appleSignInButton.snp.bottom).offset(10 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        view.addSubview(googleSignInButton)
        googleSignInButton.snp.makeConstraints {
            $0.top.equalTo(naverSignInButton.snp.bottom).offset(10 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        
        backgroundYellowImage.layer.zPosition = 0
        logoTitleImage.layer.zPosition = 1
        subtitleLabel.layer.zPosition = 1
        backgroundWhiteImage.layer.zPosition = 1
        appleSignInButton.layer.zPosition = 2
        naverSignInButton.layer.zPosition = 2
        googleSignInButton.layer.zPosition = 2
        activityIndicator.layer.zPosition = 3
    }
}
