//
//  UpdateJellyViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/24.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class UpdateJellyViewController: UIViewController {
    
    private var userNickname: String = ""
    private var maximumJelly: Int = 0
    
    private let updateJellyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(text: "선택한 액수", letterSpacing: -0.3)
        label.font = UIFont(font: .systemSemiBold, size: 15)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        return label
    }()
    private let unpaidJellyLabel: UILabel = {
        let label = UILabel(text: "1000", letterSpacing: -0.5)
        label.font = UIFont(font: .systemBold, size: 30)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        return label
    }()
    private let updateDecriptionLabel: UILabel = {
        let label = UILabel(text: "1,000원 단위로 선택할 수 있습니다.", letterSpacing: -0.3)
        label.font = UIFont(font: .systemRegular, size: 13)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        return label
    }()
    
    private let royalJellySlider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(named: "selector"), for: .normal)
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = .clear
        slider.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)
        return slider
    }()
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor(red: 255, green: 218, blue: 34)
        progressView.trackTintColor = UIColor(red: 237, green: 237, blue: 237)
        return progressView
    }()
    
    private let comfirmButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(red: 237, green: 237, blue: 237), for: .disabled)
        button.setBackgroundColor(UIColor(red: 255, green: 218, blue: 34), for: .normal)
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 15)
        button.setTitleColor(UIColor(red: 34, green: 34, blue: 34), for: .normal)
        return button
    }()
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    init(nickname: String, maxJelly: Int) {
        super.init(nibName: nil, bundle: nil)
        userNickname = nickname
        maximumJelly = maxJelly
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dismissViewByPan)))
        initRoyalJellySlider()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.backgroundColor = .clear
        
        view.addSubview(updateJellyView)
        updateJellyView.snp.makeConstraints {
            $0.top.equalTo(367 * DesignSet.frameHeightRatio)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview().offset(100)
        }
        
        updateJellyView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(42 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        updateJellyView.addSubview(unpaidJellyLabel)
        unpaidJellyLabel.snp.makeConstraints {
            $0.top.equalTo(70 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36 * DesignSet.frameHeightRatio)
        }
        
        updateJellyView.addSubview(royalJellySlider)
        royalJellySlider.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-140 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
            $0.width.equalTo(337 * DesignSet.frameWidthRatio)
        }
        updateJellyView.addSubview(progressBar)
        progressBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-126 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(6 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        
        updateJellyView.addSubview(updateDecriptionLabel)
        updateDecriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-77 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
        
        updateJellyView.addSubview(comfirmButton)
        comfirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(59 * DesignSet.frameHeightRatio)
            $0.width.equalToSuperview()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.removeGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dismissViewByPan)))
    }
}

// MARK:- UX

extension UpdateJellyViewController {
    
    // MARK: Button
    
    private func comfirmButtonControl() {
        if royalJellySlider.value == 0 {
            comfirmButton.isEnabled = false
        } else {
            comfirmButton.isEnabled = true
        }
    }
    
    // MARK: Pan Gesture
    
    @objc private func dismissCurrentView() {
        NotificationCenter.default.post(name: Notification.Name.init("DismissUpdateJellyView"), object: nil)
        dismiss(animated: true)
    }
    
    @objc private func dismissViewByPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
        case .ended:
            if viewTranslation.y < 90 {
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                    self.view.transform = .identity
                })
            } else {
                NotificationCenter.default.post(name: Notification.Name.init("DismissUpdateJellyView"), object: nil)
                dismiss(animated: true)
            }
        default:
            break
        }
    }
    
    // MARK: Slider
    
    private func initRoyalJellySlider() {
        royalJellySlider.maximumValue = Float(maximumJelly)
        royalJellySlider.minimumValue = 0
        royalJellySlider.value = 1000
        progressBar.progress = royalJellySlider.value / royalJellySlider.maximumValue
    }
    
    @objc private func didChangeSliderValue(_ sender: UISlider) {
        let value = Float(Int(sender.value / 1000) * 1000)
        sender.setValue(value, animated: false)
        progressBar.progress = sender.value / sender.maximumValue
        unpaidJellyLabel.text = "\(Int(sender.value))"
        comfirmButtonControl()
    }
}
