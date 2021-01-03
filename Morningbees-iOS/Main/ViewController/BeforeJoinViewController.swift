//
//  BeforeJoinViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/01.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit
import GoogleSignIn
import NaverThirdPartyLogin

final class BeforeJoinViewController: UIViewController, CustomAlert {
    
    // MARK:- Properties
    
    private let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private let illustBeforeJoiningImg = DesignSet.initImageView(imgName: "illustBeforeJoining")
    
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "power"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(touchUpSignOutNaver), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchUpSignOutGoogle), for: .touchUpInside)
        return button
    }()
    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconNotification"), for: .normal)
        return button
    }()
    private let firstStatusLabel: UILabel = {
        let label = DesignSet.initLabel(text: "회원님은 Bee에", letterSpacing: -0.6)
        label.textColor = DesignSet.colorSet(red: 34, green: 34, blue: 34)
        label.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 22)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    private let secondStatusLabel: UILabel = {
        let label = DesignSet.initLabel(text: "소속되어 있지 않습니다.", letterSpacing: -0.6)
        label.textColor = DesignSet.colorSet(red: 34, green: 34, blue: 34)
        label.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 22)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    private let firstAdviceLabel: UILabel = {
        let label = DesignSet.initLabel(text: "Bee(모임)를 만들어 여왕벌이 되거나", letterSpacing: -0.3)
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    private let secondAdviceLabel: UILabel = {
        let label = DesignSet.initLabel(text: "여왕벌에게 초대를 부탁하세요!", letterSpacing: -0.3)
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let createBeeButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = DesignSet.colorSet(red: 255, green: 218, blue: 34)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(touchupBeeCreateButton), for: .touchUpInside)
        button.setTitle("BEE 만들기", for: .normal)
        button.setTitleColor(DesignSet.colorSet(red: 34, green: 34, blue: 34), for: .normal)
        button.titleLabel?.font =  DesignSet.fontSet(name: TextFonts.systemSemiBold.rawValue,
                                                     size: 14)
        return button
    }()
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

// MARK:- Navigation Control

extension BeforeJoinViewController {
    
    @objc private func touchupBeeCreateButton(_ sender: UIButton) {
        NavigationControl().pushToBeeCreateNameViewController()
    }
}

// MARK:- SignOut Naver

extension BeforeJoinViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    }

    func oauth20ConnectionDidFinishDeleteToken() {
        NavigationControl().popToRootViewController()
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        presentOneButtonAlert(title: "Error!", message: error.localizedDescription)
    }

    // MARK: Action

    @objc private func touchUpSignOutNaver(_ sender: UIButton) {
        naverSignInInstance?.delegate = self
        naverSignInInstance?.resetToken()
        NavigationControl().popToRootViewController()
    }
}

// MARK:- SignOut Google

extension BeforeJoinViewController {

    // MARK: Action

    @objc private func touchUpSignOutGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        NavigationControl().popToRootViewController()
    }
}

// MARK:- View Design

extension BeforeJoinViewController {
    
    private func setupDesign() {
        view.addSubview(logOutButton)
        view.addSubview(illustBeforeJoiningImg)
        view.addSubview(notificationButton)
        
        view.addSubview(firstStatusLabel)
        view.addSubview(secondStatusLabel)
        view.addSubview(firstAdviceLabel)
        view.addSubview(secondAdviceLabel)
        
        view.addSubview(createBeeButton)
        
        DesignSet.squareConstraints(view: logOutButton, top: 49, leading: 20, height: 20, width: 20)
        DesignSet.constraints(view: illustBeforeJoiningImg, top: 83, leading: 69, height: 238, width: 238)
        DesignSet.constraints(view: notificationButton, top: 49, leading: 333, height: 20, width: 20)
        
        DesignSet.constraints(view: firstStatusLabel, top: 341, leading: 53, height: 32, width: 270)
        DesignSet.constraints(view: secondStatusLabel, top: 373, leading: 53, height: 32, width: 270)
        DesignSet.constraints(view: firstAdviceLabel, top: 426, leading: 50, height: 23, width: 276)
        DesignSet.constraints(view: secondAdviceLabel, top: 449, leading: 70, height: 23, width: 236)
        
        DesignSet.constraints(view: createBeeButton, top: 518, leading: 83, height: 50, width: 210)
    }
}
