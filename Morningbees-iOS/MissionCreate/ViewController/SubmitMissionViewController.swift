//
//  SubmitMissionViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/10.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class SubmitMissionViewContoller: UIViewController {
    
    // MARK:- Properties
    
    private let submitView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 239, green: 239, blue: 239)
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(text: "오늘의 미션 참여하기", letterSpacing: -0.64)
        label.font = UIFont(font: .systemBold, size: 16)
        label.textColor = UIColor(red: 119, green: 119, blue: 119)
        return label
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 250, green: 250, blue: 250)
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(selectImageFromCamera), for: .touchUpInside)
        return button
    }()
    private let cameraImageView: UIImageView = {
        let imageView = UIImageView(imageName: "iconCamera")
        imageView.alpha = 0.25
        return imageView
    }()
    private let cameraLabel: UILabel = {
        let label = UILabel(text: "사진찍기", letterSpacing: -0.62)
        label.font = UIFont(font: .systemBold, size: 13)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.textAlignment = .center
        return label
    }()
    
    private let libraryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 250, green: 250, blue: 250)
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(selectImageFromPhoto), for: .touchUpInside)
        return button
    }()
    private let libraryImageView: UIImageView = {
        let imageView = UIImageView(imageName: "iconPhoto")
        imageView.alpha = 0.25
        return imageView
    }()
    private let libraryLabel: UILabel = {
        let label = UILabel(text: "갤러리에서\n가져오기", letterSpacing: -0.62)
        label.font = UIFont(font: .systemBold, size: 13)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private var viewTranslation = CGPoint(x: 0, y: 0)
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissSubmitViewByPan))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissSubmitViewByTap))
        submitView.addGestureRecognizer(panGestureRecognizer)
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissSubmitViewByPan))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissSubmitViewByTap))
        submitView.removeGestureRecognizer(panGestureRecognizer)
        view.removeGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK:- UX

extension SubmitMissionViewContoller {
    
    @objc private func dismissSubmitViewByPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
        case .ended:
            if viewTranslation.y < 50 {
                view.transform = .identity
            } else {
                NotificationCenter.default.post(name: Notification.Name.init("DismissSubmitView"), object: nil)
                dismiss(animated: true)
            }
        default:
            break
        }
    }
    
    @objc private func dismissSubmitViewByTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if view.bounds.contains(sender.location(in: view))
                && !submitView.bounds.contains(sender.location(in: submitView)) {
                NotificationCenter.default.post(name: Notification.Name.init("DismissSubmitView"), object: nil)
                dismiss(animated: true)
            }
        }
    }
    
    @objc private func selectImageFromPhoto() {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name.init("DismissSubmitView"), object: nil)
            NotificationCenter.default.post(name: Notification.Name.init("MissionPhoto"), object: nil)
        }
    }
    
    @objc private func selectImageFromCamera() {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name.init("DismissSubmitView"), object: nil)
            NotificationCenter.default.post(name: Notification.Name.init("MissionCamera"), object: nil)
        }
    }
}

// MARK:- Layout

extension SubmitMissionViewContoller {
    
    private func setupLayout() {
        view.backgroundColor = .clear
        
        view.addSubview(submitView)
        submitView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(407 * DesignSet.frameHeightRatio)
            $0.centerX.width.equalToSuperview()
            $0.height.equalTo(270 * DesignSet.frameHeightRatio)
        }
        
        submitView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(30 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        submitView.addSubview(cameraButton)
        cameraButton.snp.makeConstraints {
            $0.top.equalTo(79 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(50 * DesignSet.frameWidthRatio)
            $0.height.width.equalTo(120 * DesignSet.frameWidthRatio)
        }
        cameraButton.addSubview(cameraImageView)
        cameraImageView.snp.makeConstraints {
            $0.top.equalTo(32 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(cameraButton.snp.centerX)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
            $0.width.equalTo(20 * DesignSet.frameHeightRatio)
        }
        cameraButton.addSubview(cameraLabel)
        cameraLabel.snp.makeConstraints {
            $0.top.equalTo(cameraImageView.snp.bottom).offset(15)
            $0.centerX.equalTo(cameraButton)
        }
        
        submitView.addSubview(libraryButton)
        libraryButton.snp.makeConstraints {
            $0.top.equalTo(79 * DesignSet.frameHeightRatio)
            $0.trailing.equalTo(-50 * DesignSet.frameWidthRatio)
            $0.height.width.equalTo(120 * DesignSet.frameWidthRatio)
        }
        libraryButton.addSubview(libraryImageView)
        libraryImageView.snp.makeConstraints {
            $0.top.equalTo(32 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(libraryButton.snp.centerX)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
            $0.width.equalTo(20 * DesignSet.frameHeightRatio)
        }
        libraryButton.addSubview(libraryLabel)
        libraryLabel.snp.makeConstraints {
            $0.top.equalTo(libraryImageView.snp.bottom).offset(15)
            $0.centerX.equalTo(libraryButton)
        }
    }
}
