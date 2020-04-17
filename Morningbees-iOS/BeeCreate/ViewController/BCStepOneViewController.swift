//
//  BCStepOneViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/13.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

class BCStepOneViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- Properties
    
    @IBOutlet private weak var beeNameTextView: UITextField!

    private let nextBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(touchUpNextBtn), for: .touchUpInside)
        return button
    }()
    private let btnLabel: UILabel = {
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
        beeNameTextView.delegate = self
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

extension BCStepOneViewController {
    
    @objc private func touchUpNextBtn() {
        performSegue(withIdentifier: "pushToStepTwo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  let bcStepTwoViewController = segue.destination as? BCStepTwoViewController else {
            return
        }
        bcStepTwoViewController.beeName = beeNameTextView.text ?? ""
    }
    
    @IBAction private func popToPrevious(_ sender: UIButton) {
        NavigationControl().popToPrevViewController()
    }
}

//MARK:- Touch Gesture Handling

extension BCStepOneViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        beeNameTextView.endEditing(true)
    }
}

//MARK:- Keyboard Controll

extension BCStepOneViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
         guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
             as? NSValue else {
             return
         }
         nextBtn.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.cgRectValue.height)
     }
       
     @objc private func keyboardWillHide(_ notification: Notification) {
         nextBtn.transform = .identity
     }
    
    //MARK: Button Control
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if beeNameTextView?.text != "" {
            nextBtn.isEnabled = true
            nextBtn.backgroundColor = .yellow
            btnLabel.textColor = .black
        } else {
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = .lightGray
            btnLabel.textColor = .white
        }
    }
}

//MARK:- Design

extension BCStepOneViewController {
    
    private func setupDesign() {
        view.addSubview(nextBtn)
        nextBtn.addSubview(btnLabel)
        
        DesignSet.constraints(view: nextBtn, top: 611, leading: 0, height: 56, width: 375)
        DesignSet.constraints(view: btnLabel, top: 19, leading: 88, height: 19, width: 200)
    }
}
