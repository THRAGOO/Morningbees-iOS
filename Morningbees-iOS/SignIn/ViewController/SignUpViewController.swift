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
    public var provider: String = ""
    
    private let iconImgView = DesignSet.initImageView(imgName: "iconSignUp")
    private let signUpTitleLabel: UILabel = {
        let label = DesignSet.initLabel(text: "SIGN UP", letterSpacing: 0.65)
        label.textColor = DesignSet.colorSet(red: 68, green: 68, blue: 68)
        label.font = DesignSet.fontSet(name: TextFonts.SFProDisplayBlack.rawValue, size: 30)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let highlightView: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSet.colorSet(red: 255, green: 244, blue: 190)
        return view
    }()
    private let bottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = DesignSet.colorSet(red: 211, green: 211, blue: 211).cgColor
        return view
    }()
    
    private let firstCommentLabel: UILabel = {
        let label = DesignSet.initLabel(text: "모닝비즈에 오신 것을 환영합니다.", letterSpacing: -0.5)
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoSemiBold.rawValue, size: 15)
        return label
    }()
    private let secondCommentLabel: UILabel = {
        let label = DesignSet.initLabel(text: "닉네임을 만들고", letterSpacing: -0.5)
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoSemiBold.rawValue, size: 15)
        return label
    }()
    private let thirdCommentLabel: UILabel = {
        let label = DesignSet.initLabel(text: "기상미션에 참여하세요 :)", letterSpacing: -0.5)
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoSemiBold.rawValue, size: 15)
        return label
    }()
    private let nicknameDescription: UILabel = {
        let label = DesignSet.initLabel(text: "사용할 닉네임", letterSpacing: -0.3)
        label.textColor = DesignSet.colorSet(red: 119, green: 119, blue: 119)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoSemiBold.rawValue, size: 14)
        return label
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoMedium.rawValue, size: 15)
        textField.placeholder = "2~10자 이내로 입력해 주세요."
        let attributedString = NSMutableAttributedString(string: "2~10자 이내로 입력해 주세요.")
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: -0.5,
                                      range: NSRange.init(location: 0, length: attributedString.length))
        textField.attributedPlaceholder = attributedString
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    private let validCheckLabel: UILabel = {
        let label = DesignSet.initLabel(text: "중복확인", letterSpacing: -0.3)
        label.textColor = DesignSet.colorSet(red: 68, green: 68, blue: 68)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoSemiBold.rawValue, size: 13)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private var validCheckBtn: UIButton = {
        let button = UIButton()
        button.layer.borderColor = DesignSet.colorSet(red: 229, green: 229, blue: 229).cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(touchUpVaildCheckButton), for: .touchUpInside)
        return button
    }()
    
    private let startLabel: UILabel = {
        let label = DesignSet.initLabel(text: "시작하기", letterSpacing: -0.3)
        label.textColor = DesignSet.colorSet(red: 255, green: 255, blue: 255)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoExtraBold.rawValue, size: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private var startBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSet.colorSet(red: 211, green: 211, blue: 211)
        button.addTarget(self, action: #selector(touchUpStartBtn), for: .touchUpInside)
        return button
    }()

//MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.delegate = self
        setupDesign()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        nicknameAvailableSet(false)
    }
}

//MARK:- Touch Gesture Handling

extension SignUpViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK:- Validation Request

extension SignUpViewController: CustomAlert {

    //MARK: Nickname Validation Check on Server

    func isValidNicknameServer() {
        guard let nickname = nicknameTextField.text else {
            return
        }
        let reqModel = ValidNicknameModel()
        let request = RequestSet(method: reqModel.method,
                                 path: reqModel.path)
        let validNick = Request<ValidNickname>()
        validNick.request(req: request, param: ["nickname": nickname]) { (validNickname, error) in
            DispatchQueue.main.async {
                guard let error = error else {
                    guard let validNickname = validNickname else {
                        self.presentOneButtonAlert(title: "Sorry", message: "Error ouccured! Please try again.")
                        self.nicknameAvailableSet(false)
                        return
                    }
                    if validNickname.isValid == true {
                        self.presentOneButtonAlert(title: "Valid!", message: "You can use that nickname.")
                        self.nicknameTextField.endEditing(true)
                        self.nicknameAvailableSet(true)
                    } else {
                        self.presentOneButtonAlert(title: "Not valid!", message: "Please type another nickname.")
                        self.nicknameAvailableSet(false)
                    }
                    return
                }
                self.presentOneButtonAlert(title: "Error!", message: error.localizedDescription)
                self.nicknameAvailableSet(false)
            }
        }
    }

    //MARK: Nickname Regulation Inspection

    private func inspecNicknameReg(originText: String, filter: String = "[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ]") -> Bool {
        let regulation = try? NSRegularExpression(pattern: filter, options: [])
        let newText = regulation?.matches(in: originText,
                                          options: [],
                                          range: NSRange.init(location: 0,
                                                              length: originText.count))
        if newText?.count != originText.count {
            return false
        }
        return true
    }
    
    //MARK: Nickname Validation Status
    
    private func nicknameAvailableSet(_ state: Bool) {
        if state {
            validCheckLabel.textColor = DesignSet.colorSet(red: 204, green: 204, blue: 204)
            startBtn.backgroundColor = DesignSet.colorSet(red: 255, green: 218, blue: 34)
            validCheckBtn.isEnabled = false
            startBtn.isEnabled = true
        } else {
            validCheckLabel.textColor = DesignSet.colorSet(red: 68, green: 68, blue: 68)
            startBtn.backgroundColor = DesignSet.colorSet(red: 211, green: 211, blue: 211)
            validCheckBtn.isEnabled = true
            startBtn.isEnabled = false
        }
    }
    
    //MARK: Valid Request Action
    
    @objc private func touchUpVaildCheckButton(_ sender: UIButton) {
        guard let nickname = nicknameTextField.text else {
            return
        }
        if nickname.count > 1 {
            if inspecNicknameReg(originText: nickname) == true {
                isValidNicknameServer()
            } else {
                presentOneButtonAlert(title: "Sorry", message: "nickname contains inappropriate value.")
            }
        } else {
            presentOneButtonAlert(title: "Sorry", message: "nickname is too short!")
        }
    }
}

//MARK: TextField length limit

extension SignUpViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let prospectedText = (text as NSString).replacingCharacters(in: range, with: string)
        let length = prospectedText.count
        return length < 11
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nicknameAvailableSet(false)
    }
}

//MARK:- SignUp Request

extension SignUpViewController {
    
    private func signUpRequest(_ socialAccessToken: String, _ provider: String) {
        guard let nickname = nicknameTextField.text else {
            presentOneButtonAlert(title: "Error!", message: "Couldn't get nickname")
            return
        }
        let reqModel = SignUpModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let param: [String: String] = ["socialAccessToken": socialAccessToken,
                                       "provider": provider,
                                       "nickname": nickname]
        let signUpReq = Request<SignUp>()
        signUpReq.request(req: request, param: param) { (signUp, error)  in
            if let error = error {
                self.presentOneButtonAlert(title: "Error!", message: error.localizedDescription)
            }
            guard let signUp = signUp else {
                return
            }
            
            //MARK: KeyChain
            
            KeychainService.addKeychainToken(signUp.accessToken, signUp.refreshToken) { (error) in
                if let error = error {
                    self.presentOneButtonAlert(title: "Error!", message: error.localizedDescription)
                }
            }
        }
        MeAPI().request { (alreadyJoinedBee, error) in
            if let error = error {
                self.presentOneButtonAlert(title: "Error!", message: error.localizedDescription)
            }
            guard let alreadyJoinedBee = alreadyJoinedBee else {
                return
            }
            if alreadyJoinedBee {
                NavigationControl().pushToBeeMainViewController()
            } else {
                NavigationControl().pushToBeforeJoinViewController()
            }
        }
    }
    
    //MARK: Start Button Action
    
    @objc private func touchUpStartBtn(_ sender: UIButton) {
        switch provider {
        case SignInProvider.naver.rawValue:
            guard let naverAccessToken = naverSignInInstance?.accessToken else {
                return
            }
            signUpRequest(naverAccessToken, SignInProvider.naver.rawValue)
        case SignInProvider.google.rawValue:
            guard let googleAccessToken = GIDSignIn.sharedInstance()?.currentUser.authentication.idToken else {
                return
            }
            signUpRequest(googleAccessToken, SignInProvider.google.rawValue)
        case SignInProvider.apple.rawValue:
            KeychainService.extractKeyChainAppleInfo { (_, idToken, error) in
                if let error = error {
                    self.presentOneButtonAlert(title: "Error", message: error.localizedDescription)
                }
                guard let idToken = idToken else {
                    self.presentOneButtonAlert(title: "Error!", message: "Couldn't get IdentityToken.")
                    return
                }
                self.signUpRequest(idToken, SignInProvider.apple.rawValue)
            }
        default:
            presentOneButtonAlert(title: "Error", message: "fail on request.")
        }
    }
}

//MARK:- View Design

extension SignUpViewController {
    
    private func setupDesign() {
        view.addSubview(iconImgView)
        view.addSubview(signUpTitleLabel)
        view.addSubview(highlightView)
        view.addSubview(bottomlineView)
        
        view.addSubview(firstCommentLabel)
        view.addSubview(secondCommentLabel)
        view.addSubview(thirdCommentLabel)
        view.addSubview(nicknameDescription)
        
        view.addSubview(nicknameTextField)
        view.addSubview(validCheckBtn)
        validCheckBtn.addSubview(validCheckLabel)
        
        view.addSubview(startBtn)
        startBtn.addSubview(startLabel)
        
        signUpTitleLabel.layer.zPosition = 1
        highlightView.layer.zPosition = 0
        
        DesignSet.constraints(view: iconImgView, top: 60, leading: 24, height: 36, width: 36)
        DesignSet.constraints(view: signUpTitleLabel, top: 122, leading: 24, height: 36, width: 126)
        DesignSet.constraints(view: highlightView, top: 140, leading: 24, height: 20, width: 125)
        DesignSet.constraints(view: bottomlineView, top: 360, leading: 24, height: 1, width: 327)
        
        DesignSet.flexibleConstraints(view: firstCommentLabel, top: 180, leading: 24, height: 26, width: 189)
        DesignSet.flexibleConstraints(view: secondCommentLabel, top: 206, leading: 24, height: 26, width: 189)
        DesignSet.flexibleConstraints(view: thirdCommentLabel, top: 232, leading: 24, height: 26, width: 189)
        DesignSet.flexibleConstraints(view: nicknameDescription, top: 292, leading: 24.5, height: 17, width: 75)
        
        DesignSet.flexibleConstraints(view: nicknameTextField, top: 324, leading: 24.5, height: 19, width: 240)
        DesignSet.constraints(view: validCheckBtn, top: 316, leading: 281.5, height: 36, width: 70)
        DesignSet.constraints(view: validCheckLabel, top: 10.5, leading: 13, height: 16, width: 44)
        
        DesignSet.constraints(view: startBtn, top: 611, leading: 0, height: 56, width: 375)
        DesignSet.constraints(view: startLabel, top: 20, leading: 160.5, height: 19, width: 55)
    }
}
