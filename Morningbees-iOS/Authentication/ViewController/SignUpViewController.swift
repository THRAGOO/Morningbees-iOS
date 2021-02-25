//
//  SignUpViewController.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2019/11/22.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    // MARK:- Properties
    
    public var provider: SignInProvider?
    public var socialAccessToken: String?
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.style = .large
        indicator.backgroundColor = .black
        indicator.alpha = 0.5
        return indicator
    }()
    private let activityIndicatorImageView = UIImageView(imageName: "illustErrorPage")
    private let activityIndicatorDescriptionLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: 0)
        label.textColor = .white
        label.font = UIFont(font: .systemBold, size: 24)
        return label
    }()
    
    private let iconImageView = UIImageView(imageName: "iconSignUp")
    private let signUpTitleLabel: UILabel = {
        let label = UILabel(text: "SIGN UP", letterSpacing: 0.65)
        label.textColor = UIColor(red: 68, green: 68, blue: 68)
        label.font = UIFont(font: .SFProDisplayBlack, size: 30)
        return label
    }()
    private let highlightView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255, green: 244, blue: 190)
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: -0.5)
        label.text = """
                모닝비즈에 오신 것을 환영합니다.
                닉네님을 만들고
                기상미션에 참여하세요:)
                """
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemSemiBold, size: 15)
        label.numberOfLines = 3
        return label
    }()
    private let nicknameDescription: UILabel = {
        let label = UILabel(text: "사용할 닉네임", letterSpacing: -0.3)
        label.textColor = UIColor(red: 119, green: 119, blue: 119)
        label.font = UIFont(font: .systemSemiBold, size: 14)
        return label
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(font: .systemMedium, size: 15)
        textField.placeholder = "2~10자 이내로 입력해 주세요."
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(limitTextFieldLength), for: .editingChanged)
        return textField
    }()
    private var validCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .normal)
        button.setTitleColor(UIColor(red: 204, green: 204, blue: 204), for: .disabled)
        button.titleLabel?.font = UIFont(font: .systemRegular, size: 13)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 229, green: 229, blue: 229).cgColor
        button.addTarget(self, action: #selector(touchUpVaildCheckButton), for: .touchUpInside)
        return button
    }()
    
    private let bottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 211, green: 211, blue: 211).cgColor
        return view
    }()
    private let invalidNicknameDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "2-10자 이내로 입력해 주세요."
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemMedium, size: 13)
        label.alpha = 0
        return label
    }()
    
    private var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(UIColor(red: 34, green: 34, blue: 34), for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.titleLabel?.font = UIFont(font: .systemExtraBold, size: 16)
        button.setBackgroundColor(UIColor(red: 255, green: 218, blue: 34), for: .normal)
        button.setBackgroundColor(UIColor(red: 211, green: 211, blue: 211), for: .disabled)
        button.addTarget(self, action: #selector(touchUpStartBtn), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.delegate = self
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willShowkeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willHidekeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NavigationControl.navigationController.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
}

// MARK:- UX

extension SignUpViewController {
    
    // MARK: Touch Event
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nicknameTextField.endEditing(true)
    }
    
    // MARK: Keyboard Event
    
    @objc private func willShowkeyboard(_ notification: Notification) {
        startButton.snp.remakeConstraints {
            $0.height.equalTo(56 * DesignSet.frameHeightRatio)
            $0.bottom.centerX.width.equalToSuperview()
        }
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let y = keyboardHeight * 0.3
        view.transform = CGAffineTransform(translationX: 0, y: -y)
        startButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + y)
    }
    
    @objc private func willHidekeyboard(_ notification: Notification) {
        view.transform = .identity
        startButton.transform = .identity
        startButton.snp.remakeConstraints {
            $0.height.equalTo(56 * DesignSet.frameHeightRatio)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: Nickname Validation Status
    
    private func setNicknameAvailability(_ state: Bool) {
        validCheckButton.isEnabled = !state
        startButton.isEnabled = state
    }
    
    private func setInvalidDescription(_ status: NicknameValidationStatus) {
        switch status {
        case .short:
            invalidNicknameDescriptionLabel.text = "길이가 너무 짧습니다."
        case .invalidCharacter:
            invalidNicknameDescriptionLabel.text = "닉네임에 포함될 수 없는 문자가 있습니다."
        case .alreadyInUse:
            invalidNicknameDescriptionLabel.text = "이미 사용중입니다. 다른 닉네임을 입력해 주세요."
        case .possible:
            invalidNicknameDescriptionLabel.text = "사용가능한 닉네임입니다."
        case .get:
            invalidNicknameDescriptionLabel.text = "2-10자 이내로 입력해 주세요."
        }
        
        switch status {
        case .short, .invalidCharacter, .alreadyInUse:
            invalidNicknameDescriptionLabel.textColor = UIColor(red: 235, green: 54, blue: 54)
            bottomlineView.layer.borderColor = UIColor(red: 235, green: 54, blue: 54).cgColor
            setNicknameAvailability(false)
            shakeLabel()
        case .possible:
            invalidNicknameDescriptionLabel.textColor = UIColor(red: 34, green: 34, blue: 34)
            bottomlineView.layer.borderColor = UIColor(red: 34, green: 34, blue: 34).cgColor
            setNicknameAvailability(true)
        case .get:
            invalidNicknameDescriptionLabel.textColor = UIColor(red: 170, green: 170, blue: 170)
            bottomlineView.layer.borderColor = UIColor(red: 34, green: 34, blue: 34).cgColor
            setNicknameAvailability(false)
        }
    }
    
    private func shakeLabel() {
        UIView.animate(withDuration: 0.05, delay: 0, options: [.repeat, .autoreverse]) { [self] in
            UIView.modifyAnimations(withRepeatCount: 2, autoreverses: true) {
                invalidNicknameDescriptionLabel.transform = CGAffineTransform(translationX: +10, y: 0)
                invalidNicknameDescriptionLabel.transform = .identity
            }
        }
    }
    
    @objc private func touchUpVaildCheckButton(_ sender: UIButton) {
        nicknameTextField.endEditing(true)
        guard let nickname = nicknameTextField.text else {
            return
        }
        if 1 < nickname.count {
            if inspectNicknameRegulation(originText: nickname) == true {
                requestNicknameValidation()
            } else {
                setInvalidDescription(.invalidCharacter)
            }
        } else {
            setInvalidDescription(.short)
        }
    }
    
    // MARK: Start Button Action
    
    @objc private func touchUpStartBtn(_ sender: UIButton) {
        guard let socialAccessToken = socialAccessToken,
              let provider = provider?.rawValue else {
            presentConfirmAlert(title: "요청 에러!", message: "유효하지 않은 요청입니다.")
            return
        }
        requestSignUp(socialAccessToken, provider)
    }
}

// MARK:- Validation Request

extension SignUpViewController: CustomAlert {
    
    private func requestNicknameValidation() {
        activityIndicatorDescriptionLabel.text = "중복 확인 중..."
        activityIndicator.startAnimating()
        guard let nickname = nicknameTextField.text else {
            presentConfirmAlert(title: "요청 에러!", message: "닉네임 값을 불러오지 못했습니다.")
            return
        }
        let requestModel = ValidNicknameModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let nicknameValidation = Request<ValidNickname>()
        let parameter = ["nickname": nickname]
        nicknameValidation.request(request: request, parameter: parameter) { [self] (validNickname, _, error) in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                if let error = error {
                    setNicknameAvailability(false)
                    presentConfirmAlert(title: "요청 에러!", message: error.localizedDescription)
                    return
                }
                guard let validNickname = validNickname else {
                    setNicknameAvailability(false)
                    presentConfirmAlert(title: "요청 에러!", message: "요청에서 에러가 발생하였습니다.")
                    return
                }
                if validNickname.isValid == true {
                    setInvalidDescription(.possible)
                } else {
                    setInvalidDescription(.alreadyInUse)
                }
            }
        }
    }
    
    /// Nickname Regulation Inspection
    private func inspectNicknameRegulation(originText: String, filter: String = "[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ]") -> Bool {
        let regulation = try? NSRegularExpression(pattern: filter, options: [])
        let newText = regulation?.matches(in: originText,
                                          options: [],
                                          range: NSRange.init(location: 0, length: originText.count))
        if newText?.count != originText.count {
            setInvalidDescription(.invalidCharacter)
            return false
        }
        return true
    }
}

// MARK:- TextField Delegate

extension SignUpViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        return true
    }
    
    @objc private func limitTextFieldLength(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        setInvalidDescription(.get)
        if text.count == 0 {
            bottomlineView.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
            UIView.animate(withDuration: 0.1) { [self] in
                invalidNicknameDescriptionLabel.alpha = 0
            }
        } else if inspectNicknameRegulation(originText: text) == false {
            UIView.animate(withDuration: 0.5) { [self] in
                invalidNicknameDescriptionLabel.alpha = 1
            }
            setInvalidDescription(.invalidCharacter)
        } else {
            bottomlineView.layer.borderColor = UIColor(red: 34, green: 34, blue: 34).cgColor
            UIView.animate(withDuration: 0.5) { [self] in
                invalidNicknameDescriptionLabel.alpha = 1
            }
        }
        if 10 < text.count {
            sender.text = String(text[..<text.index(text.startIndex, offsetBy: 10)])
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        setNicknameAvailability(false)
    }
}

// MARK:- SignUp Request

extension SignUpViewController {
    
    private func requestSignUp(_ socialAccessToken: String, _ provider: String) {
        activityIndicatorDescriptionLabel.text = "가입 요청 중..."
        activityIndicator.startAnimating()
        guard let nickname = nicknameTextField.text else {
            presentConfirmAlert(title: "가입 요청 에러!", message: "닉네임 값을 불러오지 못했습니다.")
            return
        }
        let requestModel = SignUpModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let parameter: [String: String] = ["socialAccessToken": socialAccessToken,
                                           "provider": provider,
                                           "nickname": nickname]
        let signUp = Request<SignUp>()
        signUp.request(request: request, parameter: parameter) { [self] (signUp, _, error)  in
            if let error = error {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "가입 요청 에러!", message: error.localizedDescription)
                return
            }
            guard let signUp = signUp else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "가입 요청 에러!", message: "")
                return
            }
            KeychainService.addKeychainToken(signUp.accessToken, signUp.refreshToken) { (error) in
                if let error = error {
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                    }
                    presentConfirmAlert(title: "키체인 토큰 에러!", message: error.localizedDescription)
                    return
                }
            }
        }
        MeAPI().request { [self] (alreadyJoinedBee, error) in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
            }
            if let error = error {
                presentConfirmAlert(title: "사용자 정보 요청 에러!", message: error.localizedDescription)
                return
            }
            guard let alreadyJoinedBee = alreadyJoinedBee else {
                presentConfirmAlert(title: "사용자 정보 요청 에러!", message: "")
                return
            }
            if alreadyJoinedBee {
                NavigationControl.pushToBeeMainViewController()
            } else {
                NavigationControl.pushToBeforeJoinViewController()
            }
        }
    }
}

// MARK:- Layout

extension SignUpViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.height.width.equalToSuperview()
        }
        activityIndicator.addSubview(activityIndicatorImageView)
        activityIndicatorImageView.snp.makeConstraints {
            $0.centerX.centerY.width.equalToSuperview()
            $0.height.equalTo(activityIndicator.snp.width)
        }
        activityIndicatorImageView.addSubview(activityIndicatorDescriptionLabel)
        activityIndicatorDescriptionLabel.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.height.equalTo(26 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(36 * DesignSet.frameHeightRatio)
            $0.width.equalTo(36 * DesignSet.frameHeightRatio)
        }
        view.addSubview(signUpTitleLabel)
        signUpTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(102 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(36 * DesignSet.frameHeightRatio)
        }
        view.addSubview(highlightView)
        highlightView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(120 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.bottom.equalTo(signUpTitleLabel.snp.bottom)
            $0.width.equalTo(signUpTitleLabel.snp.width)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(164 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(72 * DesignSet.frameHeightRatio)
        }
        view.addSubview(nicknameDescription)
        nicknameDescription.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(272 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(17 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(304 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
            $0.width.equalTo(240 * DesignSet.frameWidthRatio)
        }
        view.addSubview(validCheckButton)
        validCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(nicknameTextField.snp.centerY)
            $0.trailing.equalTo(-24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(36)
            $0.width.equalTo(70 * DesignSet.frameWidthRatio)
        }
        
        view.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(340 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        view.addSubview(invalidNicknameDescriptionLabel)
        invalidNicknameDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(bottomlineView.snp.bottom).offset(12 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.height.equalTo(56 * DesignSet.frameHeightRatio)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        highlightView.layer.zPosition = 0
        signUpTitleLabel.layer.zPosition = 1
        activityIndicator.layer.zPosition = 2
    }
}
