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
    @IBOutlet private weak var nickname: UITextField!
    @IBOutlet private weak var startBtn: UIButton!
    @IBOutlet private weak var validComment: UITextView!

//MARK:- Life Cycle

    override func viewDidLoad() {
        nickname.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        nicknameAvailableSet(false)
    }
}

//MARK:- Navigation Control

extension SignUpViewController {

    private func popToSignInViewContoller() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK:- SignOut Naver

extension SignUpViewController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    }

    func oauth20ConnectionDidFinishDeleteToken() {
        print("[Success] : Disconnect with Naver")
        popToSignInViewContoller()
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }

    //MARK: Action

    @IBAction private func touchUpSignOutNaver(_ sender: UIButton) {
        naverSignInInstance?.delegate = self
        naverSignInInstance?.resetToken()
        popToSignInViewContoller()
    }

    @IBAction private func touchUpDisconnectNaver(_ sender: UIButton) {
        naverSignInInstance?.delegate = self
        naverSignInInstance?.requestDeleteToken()
    }
}

//MARK:- SignOut Google

extension SignUpViewController {

    //MARK: Action

    @IBAction private func touchUpSignOutGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        popToSignInViewContoller()
    }

    @IBAction private func touchUpDisconnectGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.disconnect()
    }

    //MARK: Request Action
    
    @IBAction private func touchUpVaildCheckButton(_ sender: UIButton) {
        guard let nickname = nickname.text else {
            return
        }
        if nickname.count > 1 {
            if inspecNicknameReg(originText: nickname) == true {
                isValidNicknameServer()
            } else {
                self.presentOneBtnAlert(title: "Sorry", message: "nickname contains inappropriate value.")
            }
        } else {
            self.presentOneBtnAlert(title: "Sorry", message: "nickname is too short!")
        }
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
        guard let nickname = self.nickname.text else {
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
                        self.presentOneBtnAlert(title: "Sorry", message: "Error ouccured! Please try again.")
                        self.nicknameAvailableSet(false)
                        return
                    }
                    if validNickname.isValid == true {
                        self.presentOneBtnAlert(title: "Valid!", message: "You can use that nickname.")
                        self.nickname.endEditing(true)
                        self.nicknameAvailableSet(true)
                    } else {
                        self.presentOneBtnAlert(title: "Not valid!", message: "Please type another nickname.")
                        self.nicknameAvailableSet(false)
                    }
                    return
                }
                self.presentOneBtnAlert(title: "Error!", message: error.localizedDescription)
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
        self.startBtn.isHidden = !state
        self.validComment.isHidden = state
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
