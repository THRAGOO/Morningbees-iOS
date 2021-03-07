//
//  PreviewMissionViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/14.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class PreviewMissionViewController: UIViewController {
    
    // MARK:- Properties
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.style = .large
        indicator.backgroundColor = .black
        indicator.alpha = 0.5
        return indicator
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "업로드 이미지", letterSpacing: -0.3)
        label.font = UIFont(font: .systemSemiBold, size: 17)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        return label
    }()
    let cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(font: .systemMedium, size: 17)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor(red: 204, green: 204, blue: 204), for: .normal)
        button.addTarget(self, action: #selector(popToPrevViewController), for: .touchUpInside)
        return button
    }()
    let shareButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(font: .systemBold, size: 17)
        button.setTitle("공유", for: .normal)
        button.setTitleColor(UIColor(red: 246, green: 205, blue: 0), for: .normal)
        button.addTarget(self, action: #selector(requestSubmitMission), for: .touchUpInside)
        return button
    }()
    private let bottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 229, green: 229, blue: 229).cgColor
        return view
    }()
    
    private let missionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let reloadPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconReload"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.setTitle("다시 올리기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(font: .systemSemiBold, size: 14)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(touchUpReloadButton), for: .touchUpInside)
        button.alpha = 0.3
        return button
    }()
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setImage()
    }
}

// MARK:- UX

extension PreviewMissionViewController: CustomAlert {
    
    @objc private func popToPrevViewController() {
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.missionImage.rawValue)
        NavigationControl.popViewController()
    }
    
    private func setImage() {
        guard let missionImageData = UserDefaults.standard.data(forKey: UserDefaultsKey.missionImage.rawValue),
              let missionImage = UIImage(data: missionImageData) else {
            return
        }
        missionImageView.image = missionImage
    }
    
    @objc private func touchUpReloadButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.init("ReloadPhoto"), object: nil)
        popToPrevViewController()
    }
    
    // MARK:- Submit Mission Request
    
    @objc func requestSubmitMission() {
        activityIndicator.startAnimating()
        let requestModel = MissionCreateModel()
        let requestSet = RequestSet(method: requestModel.method, path: requestModel.path)
        let beeId = UserDefaults.standard.integer(forKey: UserDefaultsKey.beeId.rawValue)
        guard let image = missionImageView.image,
              let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        let missionData = ["beeId": "\(beeId)",
                           "description": "",
                           "type": "2",
                           "difficulty": "0"]
        KeychainService.extractKeyChainToken { [self] (accessToken, _, error) in
            if let error = error {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "토큰 에러!", message: error.description)
                return
            }
            guard let accessToken = accessToken else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "토큰 에러!", message: "")
                return
            }
            let header = [RequestHeader.accessToken.rawValue: accessToken]
            MultipartFormdataRequest().request(parameters: missionData,
                                               imageData: imageData,
                                               requestSet: requestSet,
                                               header: header) { (created, error) in
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                if let error = error {
                    presentConfirmAlert(title: "미션 제출 요청 에러!", message: error.description)
                    return
                }
                if created {
                    presentConfirmAlert(title: "완료!", message: "성공적으로 등록했습니다!") { _ in
                        NotificationCenter.default.post(name: Notification.Name.init("ReloadViewController"),
                                                        object: nil)
                        popToPrevViewController()
                    }
                } else {
                    presentConfirmAlert(title: "실패!", message: "등록할 수 없는 상태입니다!") { _ in
                        NotificationCenter.default.post(name: Notification.Name.init("ReloadViewController"),
                                                        object: nil)
                        popToPrevViewController()
                    }
                }
            }
        }
    }
}

// MARK:- Layout

extension PreviewMissionViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.height.width.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * ToolSet.heightRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(20 * ToolSet.heightRatio)
        }
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * ToolSet.heightRatio)
            $0.trailing.equalTo(-24 * ToolSet.widthRatio)
            $0.height.equalTo(20 * ToolSet.heightRatio)
        }
        view.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(43 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
        }
        
        view.addSubview(missionImageView)
        missionImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(134 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(view.snp.width)
            $0.width.equalToSuperview()
        }
        view.addSubview(reloadPhotoButton)
        reloadPhotoButton.snp.makeConstraints {
            $0.top.equalTo(missionImageView.snp.bottom).offset(40 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18 * ToolSet.heightRatio)
            $0.width.equalTo(100 * ToolSet.widthRatio)
        }
        
        activityIndicator.layer.zPosition = 1
    }
}
