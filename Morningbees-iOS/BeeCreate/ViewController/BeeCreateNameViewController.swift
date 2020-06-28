//
//  BeeCreateNameViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/13.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class BeeCreateNameViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- Properties
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(popToPrevious), for: .touchUpInside)
        return button
    }()
    private let helpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconQuestionMark"), for: .normal)
        return button
    }()
    
    private let firstDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "생성할 Bee의", letterSpacing: -0.5)
        label.textColor = DesignSet.colorSet(red: 34, green: 34, blue: 34)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoMedium.rawValue, size: 24)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let secondDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "이름을 정해주세요.", letterSpacing: -0.5)
        label.textColor = DesignSet.colorSet(red: 34, green: 34, blue: 34)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoMedium.rawValue, size: 24)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let nameDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "Bee 이름", letterSpacing: 0)
        label.textColor = DesignSet.colorSet(red: 119, green: 119, blue: 119)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoMedium.rawValue, size: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let beeNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoBold.rawValue, size: 16)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    private let lengthDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "X자 이내로 입력해주세요.", letterSpacing: -0.4)
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoMedium.rawValue, size: 13)
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    private let bottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = DesignSet.colorSet(red: 211, green: 211, blue: 211).cgColor
        return view
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSet.colorSet(red: 229, green: 229, blue: 229)
        button.isEnabled = false
        button.setTitle("다음 1/3", for: .normal)
        button.setTitleColor(DesignSet.colorSet(red: 255, green: 255, blue: 255), for: .normal)
        button.titleLabel?.font =  DesignSet.fontSet(name: TextFonts.appleSDGothicNeoSemiBold.rawValue,
                                                     size: 15)
        button.addTarget(self, action: #selector(touchUpNextButton), for: .touchUpInside)
        return button
    }()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        beeNameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
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

//MARK:- Segue and Navigation

extension BeeCreateNameViewController {
    
    @objc private func touchUpNextButton() {
        performSegue(withIdentifier: "pushToStepTime", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  let beeCreateTimeViewController = segue.destination as? BeeCreateTimeViewController else {
            return
        }
        beeCreateTimeViewController.beeName = beeNameTextField.text ?? ""
    }
    
    @objc private func popToPrevious(_ sender: UIButton) {
        NavigationControl().popToPrevViewController()
    }
}

//MARK:- Touch Gesture Handling

extension BeeCreateNameViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        beeNameTextField.endEditing(true)
    }
}

//MARK:- Keyboard Controll

extension BeeCreateNameViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
         guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
             as? NSValue else {
             return
         }
         nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.cgRectValue.height)
     }
       
     @objc private func keyboardWillHide(_ notification: Notification) {
         nextButton.transform = .identity
     }
    
    //MARK: Button Control
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        lengthDescriptionLabel.isHidden = false
        if beeNameTextField.text != "" {
            nextButton.isEnabled = true
            nextButton.backgroundColor = DesignSet.colorSet(red: 255, green: 218, blue: 34)
            nextButton.setTitleColor(DesignSet.colorSet(red: 34, green: 34, blue: 34), for: .normal)
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = DesignSet.colorSet(red: 229, green: 229, blue: 229)
            nextButton.setTitleColor(DesignSet.colorSet(red: 255, green: 255, blue: 255), for: .disabled)
        }
    }
}

//MARK:- Design

extension BeeCreateNameViewController {
    
    private func setupDesign() {
        view.addSubview(toPreviousButton)
        view.addSubview(helpButton)
        view.addSubview(firstDescriptionLabel)
        view.addSubview(secondDescriptionLabel)
        
        view.addSubview(nameDescriptionLabel)
        view.addSubview(beeNameTextField)
        view.addSubview(lengthDescriptionLabel)
        view.addSubview(bottomlineView)
        
        view.addSubview(nextButton)
        
        DesignSet.constraints(view: toPreviousButton, top: 42, leading: 24, height: 20, width: 12)
        DesignSet.constraints(view: helpButton, top: 42, leading: 331, height: 20, width: 20)
        
        DesignSet.constraints(view: firstDescriptionLabel, top: 90, leading: 24, height: 33, width: 174)
        DesignSet.constraints(view: secondDescriptionLabel, top: 123, leading: 24, height: 33, width: 214)
        
        DesignSet.constraints(view: nameDescriptionLabel, top: 223, leading: 24, height: 17, width: 51)
        DesignSet.constraints(view: beeNameTextField, top: 257, leading: 24, height: 20, width: 327)
        DesignSet.constraints(view: lengthDescriptionLabel, top: 304, leading: 24, height: 16, width: 145)
        DesignSet.constraints(view: bottomlineView, top: 291, leading: 24, height: 1, width: 327)
        
        DesignSet.constraints(view: nextButton, top: 611, leading: 0, height: 56, width: 375)
    }
}
