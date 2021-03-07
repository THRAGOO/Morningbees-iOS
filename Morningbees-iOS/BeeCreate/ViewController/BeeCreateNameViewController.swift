//
//  BeeCreateNameViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/13.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class BeeCreateNameViewController: UIViewController {
    
    // MARK:- Properties
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(popToPreviousViewController), for: .touchUpInside)
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(text: "생성할 모임의\n이름을 정해주세요.", letterSpacing: -0.5)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        label.font = UIFont(font: .systemMedium, size: 24)
        label.numberOfLines = 2
        return label
    }()
    
    private let nameDescriptionLabel: UILabel = {
        let label = UILabel(text: "모임명", letterSpacing: 0)
        label.textColor = UIColor(red: 119, green: 119, blue: 119)
        label.font = UIFont(font: .systemMedium, size: 14)
        return label
    }()
    private let beeNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(font: .systemBold, size: 16)
        textField.placeholder = "2~12자 이내로 입력해 주세요."
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(limitTextFieldLength), for: .editingChanged)
        return textField
    }()
    private let unavailableNameDescriptionLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: -0.4)
        label.textColor = UIColor(red: 235, green: 54, blue: 54)
        label.font = UIFont(font: .systemMedium, size: 13)
        label.alpha = 0
        return label
    }()
    private let bottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 211, green: 211, blue: 211).cgColor
        return view
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음 1/3", for: .normal)
        button.setTitleColor(UIColor(red: 170, green: 170, blue: 170), for: .disabled)
        button.setTitleColor(UIColor(red: 34, green: 34, blue: 34), for: .normal)
        button.titleLabel?.font = UIFont(font: .systemSemiBold, size: 15)
        button.setBackgroundColor(UIColor(red: 255, green: 218, blue: 34), for: .normal)
        button.setBackgroundColor(UIColor(red: 229, green: 229, blue: 229), for: .disabled)
        button.addTarget(self, action: #selector(touchUpNextButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beeNameTextField.delegate = self
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
        NavigationControl.navigationController.interactivePopGestureRecognizer?.isEnabled = true
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

// MARK:- Segue and Navigation

extension BeeCreateNameViewController {
    
    @objc private func touchUpNextButton() {
        beeNameTextField.endEditing(true)
        guard let beeName = beeNameTextField.text else {
            return
        }
        let createModel = CreateModel(title: beeName, startTime: 0, endTime: 0, pay: 0)
        let beeCreateTimeViewController = BeeCreateTimeViewController(with: createModel)
        NavigationControl.navigationController.pushViewController(beeCreateTimeViewController, animated: true)
    }
    
    @objc private func popToPreviousViewController(_ sender: UIButton) {
        NavigationControl.popViewController()
    }
}

// MARK:- UX

extension BeeCreateNameViewController {
    
    // MARK: Touch Event
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        beeNameTextField.endEditing(true)
    }
    
    // MARK: Keyboard Event
    
    @objc private func willShowkeyboard(_ notification: Notification) {
        nextButton.snp.remakeConstraints {
            $0.height.equalTo(56 * ToolSet.heightRatio)
            $0.bottom.centerX.width.equalToSuperview()
        }
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.cgRectValue.height)
    }
    
    @objc private func willHidekeyboard(_ notification: Notification) {
        nextButton.transform = .identity
        nextButton.snp.remakeConstraints {
            $0.height.equalTo(56 * ToolSet.heightRatio)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK:- TextField Delegate

extension BeeCreateNameViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        return true
    }
    
    @objc private func limitTextFieldLength(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        if text.count == 0 {
            nextButton.isEnabled = false
            bottomlineView.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
            UIView.animate(withDuration: 0.1) { [self] in
                unavailableNameDescriptionLabel.alpha = 0
            }
        } else if text.count < 2 {
            nextButton.isEnabled = false
            bottomlineView.layer.borderColor = UIColor(red: 235, green: 54, blue: 54).cgColor
            unavailableNameDescriptionLabel.text = "X 글자 수가 너무 짧아요."
            UIView.animate(withDuration: 0.5) { [self] in
                unavailableNameDescriptionLabel.alpha = 1
            }
            shakeLabel()
        } else if !inspectTextRegulation(originText: text) {
            nextButton.isEnabled = false
            unavailableNameDescriptionLabel.text = "X 포함될 수 없는 문자가 있어요."
            UIView.animate(withDuration: 0.5) { [self] in
                unavailableNameDescriptionLabel.alpha = 1
            }
            shakeLabel()
        } else {
            nextButton.isEnabled = true
            bottomlineView.layer.borderColor = UIColor(red: 34, green: 34, blue: 34).cgColor
            UIView.animate(withDuration: 0.1) { [self] in
                unavailableNameDescriptionLabel.alpha = 0
            }
        }
        if 12 < text.count {
            sender.text = String(text[..<text.index(text.startIndex, offsetBy: 12)])
        }
    }
    
    private func inspectTextRegulation(originText: String) -> Bool {
        let filter: String = "[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ~!_@#$%^&*()+=.,:;?<>/` ]"
        let regulation = try? NSRegularExpression(pattern: filter, options: [])
        let newText = regulation?.matches(in: originText,
                                          options: [],
                                          range: NSRange.init(location: 0, length: originText.count))
        if newText?.count != originText.count {
            return false
        }
        return true
    }
    
    private func shakeLabel() {
        UIView.animate(withDuration: 0.05, delay: 0, options: [.repeat, .autoreverse]) { [self] in
            UIView.modifyAnimations(withRepeatCount: 2, autoreverses: true) {
                unavailableNameDescriptionLabel.transform = CGAffineTransform(translationX: +10, y: 0)
                unavailableNameDescriptionLabel.transform = .identity
            }
        }
    }
}

// MARK:- Layout

extension BeeCreateNameViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(toPreviousButton)
        toPreviousButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * ToolSet.heightRatio)
            $0.leading.equalTo(12 * ToolSet.widthRatio)
            $0.height.equalTo(20 * ToolSet.heightRatio)
            $0.width.equalTo(30 * ToolSet.heightRatio)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(66 * ToolSet.heightRatio)
        }
        
        view.addSubview(nameDescriptionLabel)
        nameDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(203 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(17 * ToolSet.heightRatio)
        }
        
        view.addSubview(beeNameTextField)
        beeNameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(236 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(20 * ToolSet.heightRatio)
            $0.width.equalTo(327 * ToolSet.widthRatio)
        }
        view.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(271 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(1)
            $0.width.equalTo(327 * ToolSet.widthRatio)
        }
        view.addSubview(unavailableNameDescriptionLabel)
        unavailableNameDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(bottomlineView.snp.top).offset(12 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(16 * ToolSet.heightRatio)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.height.equalTo(56 * ToolSet.heightRatio)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
