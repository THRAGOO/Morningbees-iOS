//
//  UpdateJellyViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/24.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class UpdateJellyViewController: UIViewController, CustomAlert {
    
    // MARK:- Properties
    
    private var userId: Int = 0
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
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        label.font = UIFont(font: .systemSemiBold, size: 15)
        return label
    }()
    private let unpaidJellyLabel: UILabel = {
        let label = UILabel(text: "1000", letterSpacing: -0.5)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        label.font = UIFont(font: .systemBold, size: 30)
        return label
    }()
    private let updateDecriptionLabel: UILabel = {
        let label = UILabel(text: "1,000원 단위로 선택할 수 있습니다.", letterSpacing: -0.3)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemRegular, size: 13)
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
        button.setTitleColor(UIColor(red: 34, green: 34, blue: 34), for: .normal)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 15)
        button.addTarget(self, action: #selector(requestUpdateJelly), for: .touchUpInside)
        return button
    }()
    
    private var viewTranslation = CGPoint(x: 0, y: 0)
    
    // MARK:- init
    
    init(userid: Int, maxJelly: Int) {
        super.init(nibName: nil, bundle: nil)
        userId = userid
        maximumJelly = maxJelly
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        initRoyalJellySlider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dismissViewByPan)))
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
    
    private func dismissCurrentView(didUpdateJelly: Bool) {
        if didUpdateJelly {
            let userInfo = ["didUpdateJelly": didUpdateJelly] as [String: Any]
            NotificationCenter.default.post(name: Notification.Name.init("DismissUpdateJellyView"),
                                            object: nil,
                                            userInfo: userInfo)
        } else {
            NotificationCenter.default.post(name: Notification.Name.init("DismissUpdateJellyView"), object: nil)
        }
        dismiss(animated: true)
    }
    
    @objc private func dismissViewByPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
        case .ended:
            if viewTranslation.y < 90 {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [self] in
                    view.transform = .identity
                }
            } else {
                dismissCurrentView(didUpdateJelly: false)
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
        var value = Int(sender.value / 500)
        if (value % 2) != 0 {
            value += 1
        }
        value *= 500
        sender.setValue(Float(value), animated: false)
        progressBar.progress = sender.value / sender.maximumValue
        unpaidJellyLabel.text = "\(value)"
        comfirmButtonControl()
    }
}

// MARK:- Update Jelly Reqeust

extension UpdateJellyViewController {
    
    @objc private func requestUpdateJelly() {
        let requestModel = UpdateJellyModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let updateJelly = Request<UpdateJelly>()
        KeychainService.extractKeyChainToken { [self] (accessToken, _, error) in
            if let error = error {
                self.presentConfirmAlert(title: "토큰 에러!", message: error.description)
            }
            guard let accessToken = accessToken else {
                return
            }
            let penalties = [Penalty(nickname: "", userId: userId, penalty: Int(royalJellySlider.value))]
            let parameter = Penalties(penalties: penalties)
            let header: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            updateJelly.request(request: request, header: header, parameter: parameter) { (_, success, error) in
                if success {
                    DispatchQueue.main.async {
                        dismissCurrentView(didUpdateJelly: true)
                    }
                } else {
                    if let error = error {
                        presentConfirmAlert(title: "로열 젤리 업데이트 요청 에러!", message: error.description)
                        return
                    }
                    presentConfirmAlert(title: "로열 젤리 업데이트 요청 에러!", message: "요청이 성공적으로 수행되지 못했습니다.") { _ in
                        DispatchQueue.main.async {
                            dismissCurrentView(didUpdateJelly: false)
                        }
                    }
                }
            }
        }
    }
}

// MARK:- Layout

extension UpdateJellyViewController {
    
    private func setLayout() {
        view.backgroundColor = .clear
        
        view.addSubview(updateJellyView)
        updateJellyView.snp.makeConstraints {
            $0.top.equalTo(367 * ToolSet.heightRatio)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview().offset(100)
        }
        
        updateJellyView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(42 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19 * ToolSet.heightRatio)
        }
        updateJellyView.addSubview(unpaidJellyLabel)
        unpaidJellyLabel.snp.makeConstraints {
            $0.top.equalTo(70 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36 * ToolSet.heightRatio)
        }
        
        updateJellyView.addSubview(royalJellySlider)
        royalJellySlider.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-140 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20 * ToolSet.heightRatio)
            $0.width.equalTo(337 * ToolSet.widthRatio)
        }
        updateJellyView.addSubview(progressBar)
        progressBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-126 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(6 * ToolSet.heightRatio)
            $0.width.equalTo(327 * ToolSet.widthRatio)
        }
        
        updateJellyView.addSubview(updateDecriptionLabel)
        updateDecriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-77 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(16 * ToolSet.heightRatio)
        }
        
        updateJellyView.addSubview(comfirmButton)
        comfirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.width.equalToSuperview()
            $0.height.equalTo(59 * ToolSet.heightRatio)
        }
    }
}
