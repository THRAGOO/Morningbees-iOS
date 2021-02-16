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
    private let lengthDescriptionLabel: UILabel = {
        let label = UILabel(text: "X 글자 수가 너무 짧아요.", letterSpacing: -0.4)
        label.textColor = UIColor(red: 235, green: 54, blue: 54)
        label.font = UIFont(font: .systemMedium, size: 13)
        label.adjustsFontSizeToFitWidth = true
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
    
    /// Home Indicator Control
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .bottom
    }
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beeNameTextField.delegate = self
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willShowkeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willHidekeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
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
        performSegue(withIdentifier: "pushToStepTime", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  let beeCreateTimeViewController = segue.destination as? BeeCreateTimeViewController else {
            return
        }
        beeCreateTimeViewController.beeName = beeNameTextField.text ?? ""
    }
    
    @objc private func popToPreviousViewController(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
         guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
             return
         }
         nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.cgRectValue.height)
     }
    
     @objc private func willHidekeyboard(_ notification: Notification) {
         nextButton.transform = .identity
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
            bottomlineView.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
        } else if text.count < 2 {
            nextButton.isEnabled = false
            bottomlineView.layer.borderColor = UIColor(red: 235, green: 54, blue: 54).cgColor
            UIView.animate(withDuration: 0.5) { [self] in
                lengthDescriptionLabel.alpha = 1
            }
            shakeLabel()
        } else {
            nextButton.isEnabled = true
            bottomlineView.layer.borderColor = UIColor(red: 34, green: 34, blue: 34).cgColor
            UIView.animate(withDuration: 0.1) { [self] in
                lengthDescriptionLabel.alpha = 0
            }
        }
        if 12 < text.count {
            sender.text = String(text[..<text.index(text.startIndex, offsetBy: 12)])
        }
    }
    
    private func shakeLabel() {
        UIView.animate(withDuration: 0.05, delay: 0, options: [.repeat, .autoreverse]) { [self] in
            UIView.modifyAnimations(withRepeatCount: 2, autoreverses: true) {
                lengthDescriptionLabel.transform = CGAffineTransform(translationX: +10, y: 0)
                lengthDescriptionLabel.transform = .identity
            }
        }
    }
}

// MARK:- Layout

extension BeeCreateNameViewController {
    
    private func setLayout() {
        view.addSubview(toPreviousButton)
        toPreviousButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(12 * DesignSet.frameWidthRatio)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
            $0.width.equalTo(12 * DesignSet.frameWidthRatio)
        }
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(66 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(nameDescriptionLabel)
        nameDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(203 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(17 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(beeNameTextField)
        beeNameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(236 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        view.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(271 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(1 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        view.addSubview(lengthDescriptionLabel)
        lengthDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(bottomlineView.snp.top).offset(12 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom).offset(-56 * DesignSet.frameHeightRatio)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
