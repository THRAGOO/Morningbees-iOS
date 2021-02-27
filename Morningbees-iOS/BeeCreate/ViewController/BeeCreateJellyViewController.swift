//
//  BeeCreateJellyViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/13.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class BeeCreateJellyViewController: UIViewController {
    
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
        let label = UILabel(text: "모임 생성 요청 중...", letterSpacing: 0)
        label.textColor = .white
        label.font = UIFont(font: .systemBold, size: 24)
        return label
    }()
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(popToPreviousViewController), for: .touchUpInside)
        return button
    }()
    
    private let firstDescriptionLabel: UILabel = {
        let label = UILabel(text: "로얄 젤리를\n설정해주세요", letterSpacing: -0.5)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        label.font = UIFont(font: .systemMedium, size: 24)
        label.numberOfLines = 2
        return label
    }()
    private let secondDescriptionLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: -0.5)
        label.text = """
            '로열젤리'는 모닝비즈 내 벌금이에요.
            매일 진행되는 미션을 수행하지 못한 꿀벌에게 부과해요.
            """
        label.textColor = UIColor(red: 204, green: 204, blue: 204)
        label.font = UIFont(font: .systemMedium, size: 13)
        label.numberOfLines = 2
        return label
    }()
    
    private let jellyDescriptionLabel: UILabel = {
        let label = UILabel(text: "로얄젤리 (최소2,000~최대 10,000원)", letterSpacing: 0)
        label.textColor = UIColor(red: 119, green: 119, blue: 119)
        label.font = UIFont(font: .systemMedium, size: 14)
        return label
    }()
    
    private let royaljellySlider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(named: "btnJellyStartPointSelect"), for: .normal)
        slider.setThumbImage(UIImage(named: "royaljellySelctorChange"), for: .highlighted)
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = .clear
        slider.maximumValue = 10000
        slider.minimumValue = 2000
        slider.value = 4000
        slider.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)
        return slider
    }()
    private let trackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = UIColor(red: 242, green: 242, blue: 242)
        view.layer.cornerRadius = 9
        view.axis = .horizontal
        view.distribution = .equalCentering
        for index in 0...8 {
            let label = UILabel()
            if index < 3 {
                label.text = "   ●"
            } else if index < 6 {
                label.text = "●"
            } else {
                label.text = "●   "
            }
            label.textColor = UIColor(red: 119, green: 119, blue: 119)
            label.font = UIFont(font: .systemMedium, size: 8)
            label.alpha = 0.24
            view.addArrangedSubview(label)
        }
        return view
    }()
    
    private let curRoyalJellyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 68, green: 68, blue: 68)
        label.font = UIFont(font: .systemBold, size: 13)
        label.isHidden = true
        return label
    }()
    private let minRoyalJellyLabel: UILabel = {
        let label = UILabel()
        label.text = "2,000"
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemMedium, size: 13)
        return label
    }()
    private let maxRoyalJellyLabel: UILabel = {
        let label = UILabel()
        label.text = "10,000"
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemMedium, size: 13)
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setTitle("Bee 시작하기", for: .normal)
        button.setTitle("다음 3/3", for: .disabled)
        button.setTitleColor(UIColor(red: 34, green: 34, blue: 34), for: .normal)
        button.setTitleColor(UIColor(red: 170, green: 170, blue: 170), for: .disabled)
        button.setBackgroundColor(UIColor(red: 255, green: 218, blue: 34), for: .normal)
        button.setBackgroundColor(UIColor(red: 229, green: 229, blue: 229), for: .disabled)
        button.titleLabel?.font = UIFont(font: .systemSemiBold, size: 15)
        button.addTarget(self, action: #selector(touchUpNextButton), for: .touchUpInside)
        return button
    }()
    
    private var createModel = CreateModel(title: "", startTime: 0, endTime: 0, pay: 0)
    
    // MARK:- Life Cycle
    
    init(with createModel: CreateModel) {
        super.init(nibName: nil, bundle: nil)
        self.createModel = createModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NavigationControl.navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK:- Navigation Control

extension BeeCreateJellyViewController {
    
    @objc private func touchUpNextButton(_ sender: UIButton) {
        requestBeeCreate()
    }
    
    @objc private func popToPreviousViewController(_ sender: UIButton) {
        NavigationControl.popViewController()
    }
}

// MARK:- Slider Control

extension BeeCreateJellyViewController {
    
    private func updateJellyLabel(min: Bool, max: Bool, cur: Bool) {
        let selectedJellyColor = UIColor(red: 68, green: 68, blue: 68)
        let notSelectedJellyColor = UIColor(red: 170, green: 170, blue: 170)
        
        let selectedJellyFont = UIFont(font: .systemBold, size: 13)
        let notSelectedJellyFont = UIFont(font: .systemMedium, size: 13)
        
        minRoyalJellyLabel.textColor = min ? selectedJellyColor : notSelectedJellyColor
        minRoyalJellyLabel.font = min ? selectedJellyFont : notSelectedJellyFont
        
        maxRoyalJellyLabel.textColor = max ? selectedJellyColor : notSelectedJellyColor
        maxRoyalJellyLabel.font = max ? selectedJellyFont : notSelectedJellyFont
        
        curRoyalJellyLabel.isHidden = cur ? false : true
    }
    
    @objc private func didChangeSliderValue(_ sender: UISlider) {
        var royalJelly = Int(sender.value / 500)
        if (royalJelly % 2) != 0 {
            royalJelly += 1
        }
        royalJelly *= 500
        sender.setValue(Float(royalJelly), animated: false)
        createModel.pay = royalJelly
        if royalJelly == 2000 {
            updateJellyLabel(min: true, max: false, cur: false)
        } else if royalJelly == 10000 {
            updateJellyLabel(min: false, max: true, cur: false)
        } else {
            updateJellyLabel(min: false, max: false, cur: true)
            curRoyalJellyLabel.text = "\(Int(sender.value))"
        }
        
        let jellyIndex = (royalJelly / 1000) - 2
        let jellyStartPosition = CGFloat(Double(36 * jellyIndex) * DesignSet.frameWidthRatio)
        UIView.animate(withDuration: 0.1) {
            self.curRoyalJellyLabel.transform = .identity
            self.curRoyalJellyLabel.transform = CGAffineTransform(translationX: +jellyStartPosition, y: 0)
        }
        nextButton.isEnabled = true
    }
}

// MARK:- Bee Create Request

extension BeeCreateJellyViewController: CustomAlert {
    
    private func requestBeeCreate() {
        activityIndicator.startAnimating()
        let requestModel = BeeCreateModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let beeCreate = Request<BeeCreate>()
        let parameter = createModel
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
            beeCreate.request(request: request, header: header, parameter: parameter) { (_, created, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                    }
                    presentConfirmAlert(title: "모임 생성 에러!", message: error.localizedDescription)
                }
                if created {
                    presentConfirmAlert(title: "", message: "성공적으로 모임을 생성하였습니다.") { _ in 
                        MeAPI().request { [self] (alreadyJoinBee, error) in
                            DispatchQueue.main.async {
                                activityIndicator.stopAnimating()
                            }
                            if let error = error {
                                presentConfirmAlert(title: "모임 생성 에러!", message: error.localizedDescription)
                                return
                            }
                            guard let alreadyJoinBee = alreadyJoinBee else {
                                presentConfirmAlert(title: "모임 생성 에러!", message: "")
                                return
                            }
                            if alreadyJoinBee {
                                NavigationControl.pushToBeeMainViewController()
                            } else {
                                NavigationControl.pushToBeforeJoinViewController()
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK:- Layout

extension BeeCreateJellyViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        
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
        
        view.addSubview(toPreviousButton)
        toPreviousButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(12 * DesignSet.frameWidthRatio)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
            $0.width.equalTo(12 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(firstDescriptionLabel)
        firstDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(66 * DesignSet.frameHeightRatio)
        }
        view.addSubview(secondDescriptionLabel)
        secondDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(151 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(36 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(jellyDescriptionLabel)
        jellyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(213 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(17 * DesignSet.frameHeightRatio)
        }
        view.addSubview(trackView)
        trackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(251 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(14 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        view.addSubview(royaljellySlider)
        royaljellySlider.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(251 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(14 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        
        view.addSubview(minRoyalJellyLabel)
        minRoyalJellyLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(281 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(20 * DesignSet.frameWidthRatio)
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
        view.addSubview(maxRoyalJellyLabel)
        maxRoyalJellyLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(281 * DesignSet.frameHeightRatio)
            $0.trailing.equalTo(-20 * DesignSet.frameWidthRatio)
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
        view.addSubview(curRoyalJellyLabel)
        curRoyalJellyLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(281 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(26 * DesignSet.frameWidthRatio)
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.height.equalTo(56 * DesignSet.frameHeightRatio)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        trackView.layer.zPosition = 0
        royaljellySlider.layer.zPosition = 1
        activityIndicator.layer.zPosition = 2
    }
}
