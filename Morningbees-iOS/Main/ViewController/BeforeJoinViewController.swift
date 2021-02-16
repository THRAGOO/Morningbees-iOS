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
    
    private let illustBeforeJoiningImg = UIImageView(imageName: "illustBeforeJoining")
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(touchUpSignOutNaver), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchUpSignOutGoogle), for: .touchUpInside)
        return button
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel(text: "회원님은 모임에\n소속되어 있지 않습니다.", letterSpacing: -0.6)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        label.font = UIFont(font: .systemBold, size: 22)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private let adviceLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: -0.3)
        label.text = "모임을 만들어 여왕벌이 되거나\n여왕벌에게 초대를 부탁하세요!"
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemMedium, size: 16)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let createBeeButton: UIButton = {
       let button = UIButton()
        button.setTitle("모임 만들기", for: .normal)
        button.setTitleColor(UIColor(red: 34, green: 34, blue: 34), for: .normal)
        button.titleLabel?.font = UIFont(font: .systemSemiBold, size: 14)
        button.backgroundColor = UIColor(red: 255, green: 218, blue: 34)
        button.setRatioCornerRadius(25)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(touchUpBeeCreateButton), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

// MARK:- Navigation Control

extension BeforeJoinViewController {
    
    @objc private func touchUpBeeCreateButton(_ sender: UIButton) {
        navigationController?.pushViewController(BeeCreateNameViewController(), animated: true)
    }
}

// MARK:- SignOut Naver

extension BeforeJoinViewController: NaverThirdPartyLoginConnectionDelegate {
    
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    }

    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    }

    public func oauth20ConnectionDidFinishDeleteToken() {
        navigationController?.popToRootViewController(animated: true)
    }

    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        presentConfirmAlert(title: "네이버 로그인 에러!", message: error.localizedDescription)
    }

    // MARK: Action

    @objc private func touchUpSignOutNaver(_ sender: UIButton) {
        naverSignInInstance?.delegate = self
        naverSignInInstance?.requestDeleteToken()
    }
}

// MARK:- SignOut Google

extension BeforeJoinViewController {

    // MARK: Action

    @objc private func touchUpSignOutGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK:- Layout

extension BeforeJoinViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(logOutButton)
        logOutButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(illustBeforeJoiningImg)
        illustBeforeJoiningImg.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(67 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(240 * DesignSet.frameHeightRatio)
            $0.width.equalTo(240 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(344 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(66 * DesignSet.frameHeightRatio)
        }
        view.addSubview(adviceLabel)
        adviceLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(431 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(createBeeButton)
        createBeeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(510 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50 * DesignSet.frameHeightRatio)
            $0.width.equalTo(210 * DesignSet.frameWidthRatio)
        }
    }
}
