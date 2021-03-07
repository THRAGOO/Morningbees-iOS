//
//  BeforeJoinViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/01.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class BeforeJoinViewController: UIViewController, CustomAlert {
    
    // MARK:- Properties
    
    private let illustBeforeJoiningImg = UIImageView(imageName: "illustBeforeJoining")
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 13)
        button.addTarget(self, action: #selector(touchUpSignOut), for: .touchUpInside)
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
        NavigationControl.navigationController.interactivePopGestureRecognizer?.isEnabled = false
    }
}

// MARK:- Navigation Control

extension BeforeJoinViewController {
    
    @objc private func touchUpBeeCreateButton(_ sender: UIButton) {
        NavigationControl.pushToBeeCreateViewController()
    }
}

// MARK:- SignOut

extension BeforeJoinViewController {
    
    private func removeAllInfomations() {
        KeychainService.deleteKeychainToken { [self] error in
            if let error = error {
                presentConfirmAlert(title: "토큰 에러!", message: error.description)
            }
        }
        UserDefaultsKey.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }

    @objc private func touchUpSignOut(_ sender: UIButton) {
        removeAllInfomations()
        NavigationControl.popToRootViewController()
    }
}

// MARK:- Layout

extension BeforeJoinViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(logOutButton)
        logOutButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(15 * ToolSet.heightRatio)
            $0.width.greaterThanOrEqualTo(20 * ToolSet.widthRatio)
        }
        
        view.addSubview(illustBeforeJoiningImg)
        illustBeforeJoiningImg.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(67 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(240 * ToolSet.heightRatio)
        }
        
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(344 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(66 * ToolSet.heightRatio)
        }
        view.addSubview(adviceLabel)
        adviceLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(431 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40 * ToolSet.heightRatio)
        }
        
        view.addSubview(createBeeButton)
        createBeeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(510 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50 * ToolSet.heightRatio)
            $0.width.equalTo(210 * ToolSet.widthRatio)
        }
    }
}
