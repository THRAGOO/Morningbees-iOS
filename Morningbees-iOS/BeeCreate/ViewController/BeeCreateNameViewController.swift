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
    
    @IBOutlet private weak var beeNameTextField: UITextField!

    private let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(touchUpNextButton), for: .touchUpInside)
        return button
    }()
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "다음 1/3"
        label.textColor = .white
        label.textAlignment = .center
        return label
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
    
    @IBAction private func popToPrevious(_ sender: UIButton) {
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
        if beeNameTextField?.text != "" {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .yellow
            buttonLabel.textColor = .black
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .lightGray
            buttonLabel.textColor = .white
        }
    }
}

//MARK:- Design

extension BeeCreateNameViewController {
    
    private func setupDesign() {
        view.addSubview(nextButton)
        nextButton.addSubview(buttonLabel)
        
        DesignSet.constraints(view: nextButton, top: 611, leading: 0, height: 56, width: 375)
        DesignSet.constraints(view: buttonLabel, top: 19, leading: 88, height: 19, width: 200)
    }
}
