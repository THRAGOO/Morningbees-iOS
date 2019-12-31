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
    @IBOutlet weak var nickname: UITextField!

//MARK:- Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
        if isValidNicknameClient() {
            isValidNicknameServer()
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

extension SignUpViewController {
    
    //MARK: Server's Vaildation Check
    
    private func isValidNicknameServer() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        NetworkRequest.fetchData(url: AssembleURL.getURL(subURL: SubURL.validNickname,
                                                         value: nickname?.text)) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                guard let data = data else {
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    let serverError = try? JSONDecoder().decode(ServerError.self, from: data)
                    alert.title = ServerErrAlert.title.rawValue
                    alert.message = serverError?.message
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                let validation = try? JSONDecoder().decode(ValidNickname.self, from: data)
                alert.title = NicknameAlert.title.rawValue
                if validation?.isValid ?? false {
                    alert.message = NicknameAlert.valid.rawValue
                } else {
                    alert.message = NicknameAlert.notValid.rawValue
                }
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: Client's Vaildation Check
    
    private func isValidNicknameClient() -> Bool {
        let alert = UIAlertController(title: NicknameAlert.title.rawValue,
                                      message: NicknameAlert.notValid.rawValue,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        if let nickName = nickname.text {
            if nickName.count < 2 || 10 < nickName.count {
                alert.message = NicknameAlert.lengthErr.rawValue
                self.present(alert, animated: true, completion: nil)
                return false
            } else {
                if checkString(originText: nickName) {
                    return true
                } else {
                    alert.message = NicknameAlert.regulationErr.rawValue
                    self.present(alert, animated: true, completion: nil)
                    return false
                }
            }
        } else {
            return false
        }
    }
    
    //MARK: Regulation Check
    
    private func checkString(originText: String, filter: String = "[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]") -> Bool {
        let regulation = try? NSRegularExpression(pattern: filter, options: [])
        let newText = regulation?.matches(in: originText,
                                          options: [],
                                          range: NSRange.init(location: 0, length: originText.count))
        if newText?.count != originText.count {
            return false
        }
        return true
    }
}
