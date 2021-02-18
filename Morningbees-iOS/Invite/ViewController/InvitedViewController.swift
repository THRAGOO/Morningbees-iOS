//
//  InvitedViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/08/26.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class InvitedViewController: UIViewController {
    
    // MARK:- Properties
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.style = .large
        indicator.backgroundColor = .black
        indicator.alpha = 0.5
        return indicator
    }()
    private let activityIndicatorImageView = UIImageView(imageName: "illustErrorPage")
    private let activityIndicatorDescriptionLabel: UILabel = {
        let label = UILabel(text: "모임 참여 요청 중...", letterSpacing: 0)
        label.textColor = .white
        label.font = UIFont(font: .systemBold, size: 24)
        return label
    }()
    
    private let invitationImageViwe = UIImageView(imageName: "illustInvite")
    private let mainDescriptionLabel: UILabel = {
        let label = UILabel(text: "여왕벌에게\n초대장이 도착하였습니다.", letterSpacing: -0.6)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        label.font = UIFont(font: .systemBold, size: 24)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private let invitedLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: -0.26)
        label.textColor = UIColor(red: 68, green: 68, blue: 68)
        label.font = UIFont(font: .systemMedium, size: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private var beeTitle: String = ""
    private let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("모임에 참여하기", for: .normal)
        button.setTitleColor(UIColor(red: 34, green: 34, blue: 34), for: .normal)
        button.titleLabel?.font = UIFont(font: .systemSemiBold, size: 14)
        button.backgroundColor = UIColor(red: 255, green: 218, blue: 34)
        button.setRatioCornerRadius(25)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(touchUpJoinButton), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBeeTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

// MARK:- UX

extension InvitedViewController {
    
    @objc private func touchUpJoinButton(_ sender: UIButton) {
        requestJoinBee()
    }
}

// MARK:- UI

extension InvitedViewController {
    
    private func setBeeTitle() {
        guard let beeTitle = UserDefaults.standard.string(forKey: UserDefaultsKey.beeTitle.rawValue) else {
            return
        }
        invitedLabel.text = "\(beeTitle)에 참여하여\n미션을 함께 클리어 해 볼까요?"
        self.beeTitle = beeTitle
    }
}

// MARK:- Join Request

extension InvitedViewController: CustomAlert {
    
    private func requestJoinBee() {
        activityIndicator.startAnimating()
        let requestModel = JoinBeeModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let joinBee = Request<JoinBee>()
        let beeId = UserDefaults.standard.integer(forKey: UserDefaultsKey.beeId.rawValue)
        let userId = UserDefaults.standard.integer(forKey: UserDefaultsKey.userId.rawValue)
        let parameter = JoinBeeParameter(beeId: beeId, userId: userId, title: beeTitle)
        KeychainService.extractKeyChainToken { [self] (accessToken, _, error) in
            if let error = error {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "토큰 에러!", message: error.localizedDescription)
                return
            }
            guard let accessToken = accessToken else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "토큰 에러!", message: "")
                return
            }
            let header: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            joinBee.request(request: request, header: header, parameter: parameter) { [self] (_, joined, error) in
                if joined {
                    MeAPI().request { (alreadyJoinedBee, error) in
                        DispatchQueue.main.async {
                            activityIndicator.stopAnimating()
                        }
                        if let error = error {
                            presentConfirmAlert(title: "사용자 정보 요청 에러!", message: error.localizedDescription)
                            return
                        }
                        guard let alreadyJoinedBee = alreadyJoinedBee else {
                            presentConfirmAlert(title: "사용자 정보 요청 에러!", message: "")
                            return
                        }
                        if alreadyJoinedBee {
                            navigationController?.pushViewController(BeeMainViewController(), animated: true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                    }
                    if let error = error {
                        presentConfirmAlert(title: "모임 참여 에러!", message: error.localizedDescription)
                        return
                    }
                    presentConfirmAlert(title: "모임 참여 에러!", message: "모임 참여에 실패했습니다.")
                }
            }
        }
    }
}

// MARK:- Layout

extension InvitedViewController {
    
    private func setLayout() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.height.width.equalToSuperview()
        }
        activityIndicator.addSubview(activityIndicatorImageView)
        activityIndicatorImageView.snp.makeConstraints {
            $0.centerX.centerY.width.equalToSuperview()
            $0.height.equalTo(activityIndicator.snp.width)
        }
        activityIndicatorImageView.addSubview(activityIndicatorDescriptionLabel)
        activityIndicatorDescriptionLabel.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.height.equalTo(26 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(invitationImageViwe)
        invitationImageViwe.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(67 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(240 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(mainDescriptionLabel)
        mainDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(344 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(66 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(invitedLabel)
        invitedLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(431 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40 * DesignSet.frameHeightRatio)
        }
        view.addSubview(joinButton)
        joinButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(510 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50 * DesignSet.frameHeightRatio)
            $0.width.equalTo(210 * DesignSet.frameWidthRatio)
        }
        
        activityIndicator.layer.zPosition = 1
    }
}
