//
//  BeeCreateTimeViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/13.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class BeeCreateTimeViewController: UIViewController {
    
    // MARK:- Properties
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(popToPreviousViewController), for: .touchUpInside)
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(text: "미션 수행 시간을\n선택해 주세요.", letterSpacing: -0.5)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        label.font = UIFont(font: .systemMedium, size: 24)
        label.numberOfLines = 2
        return label
    }()
    private let timeDescriptionLabel: UILabel = {
        let label = UILabel(text: "시작 및 종료 시간", letterSpacing: 0)
        label.textColor = UIColor(red: 119, green: 119, blue: 119)
        label.font = UIFont(font: .systemMedium, size: 14)
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("미션 시작시간을 선택해 주세요.", for: .disabled)
        button.setTitle("다음 2/3", for: .normal)
        button.setTitleColor(UIColor(red: 34, green: 34, blue: 34), for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.titleLabel?.font = UIFont(font: .systemSemiBold, size: 15)
        button.setBackgroundColor(UIColor(red: 255, green: 218, blue: 34), for: .normal)
        button.setBackgroundColor(UIColor(red: 229, green: 229, blue: 229), for: .disabled)
        button.addTarget(self, action: #selector(touchUpNextButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private var timeButtons = [UIButton]()
    private let timeSelectStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var createModel = CreateModel(title: "", startTime: 0, endTime: 0, pay: 0)
    private let none = 11
    
    // MARK:- Life Cycle
    
    init(with createModel: CreateModel) {
        super.init(nibName: nil, bundle: nil)
        self.createModel = createModel
        self.createModel.startTime = none
        self.createModel.endTime = none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NavigationControl.navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK:- Segue and Navigation

extension BeeCreateTimeViewController {
    
    @objc private func touchUpNextButton() {
        let beeCreateJellyViewController = BeeCreateJellyViewController(with: createModel)
        NavigationControl.navigationController.pushViewController(beeCreateJellyViewController, animated: true)
    }
    
    @objc private func popToPreviousViewController(_ sender: UIButton) {
        NavigationControl.popViewController()
    }
}

// MARK:- Mission Time Button Set

extension BeeCreateTimeViewController {
    
    private func setupButton() {
        for idx in 0..<5 {
            let button = UIButton()
            button.backgroundColor = UIColor(red: 249, green: 249, blue: 249)
            button.setBackgroundImage(UIImage(named: "btnTimeOutline"), for: .normal)
            button.setBackgroundImage(UIImage(named: "btnTimeOutline"), for: .highlighted)
            button.setBackgroundImage(UIImage(named: "btnTimeOutline"), for: [.selected, .highlighted])
            button.setTitle(String(idx + 6), for: .normal)
            button.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .normal)
            button.titleLabel?.font = UIFont(font: .systemSemiBold, size: 16)
            button.addTarget(self, action: #selector(didTapRatingButton), for: .touchUpInside)
            timeSelectStackView.addArrangedSubview(button)
            timeButtons.append(button)
        }
    }
    
    private func setupButtonLabel(_ state: TimeButtonState) {
        if state == .start {
            nextButton.setTitle("미션 시작시간을 선택해 주세요.", for: .disabled)
        } else if state == .end {
            nextButton.setTitle("미션 종료시간을 선택해 주세요.", for: .disabled)
        }
    }
    
    private func didSelectTimeButton(_ state: Bool, _ index: Int) {
        timeButtons[index].isSelected = state ? true : false
        let disabledColor = UIColor(red: 249, green: 249, blue: 249)
        switch index {
        case 0:
            let enabledColor = UIColor(red: 255, green: 239, blue: 142)
            timeButtons[index].backgroundColor = state ? enabledColor : disabledColor
        case 1:
            let enabledColor = UIColor(red: 255, green: 226, blue: 81)
            timeButtons[index].backgroundColor = state ? enabledColor : disabledColor
        case 2:
            let enabledColor = UIColor(red: 251, green: 201, blue: 50)
            timeButtons[index].backgroundColor = state ? enabledColor : disabledColor
        case 3:
            let enabledColor = UIColor(red: 242, green: 159, blue: 6)
            timeButtons[index].backgroundColor = state ? enabledColor : disabledColor
        case 4:
            let enabledColor = UIColor(red: 238, green: 128, blue: 7)
            timeButtons[index].backgroundColor = state ? enabledColor : disabledColor
        default:
            break
        }
    }
    
    @objc private func didTapRatingButton(button: UIButton) {
        guard let index = timeButtons.firstIndex(of: button) else {
            return
        }
        let selectedTime = index + 6
        
        if createModel.startTime == none && timeButtons[index].isSelected == false {
            createModel.startTime = selectedTime
            didSelectTimeButton(true, index)
            if createModel.startTime == 10 {
                setupButtonLabel(.start)
            } else {
                setupButtonLabel(.end)
            }
        } else if createModel.endTime == none && timeButtons[index].isSelected == false {
            createModel.endTime = selectedTime
            didSelectTimeButton(true, index)
        } else if createModel.startTime == selectedTime || createModel.endTime == selectedTime {
            if createModel.startTime == selectedTime {
                createModel.startTime = none
                setupButtonLabel(.start)
            } else {
                createModel.endTime = none
                if createModel.startTime == none && createModel.endTime == none {
                    setupButtonLabel(.start)
                } else {
                    setupButtonLabel(.end)
                }
            }
            didSelectTimeButton(false, index)
        }
        
        if createModel.startTime > createModel.endTime {
            swap(&createModel.startTime, &createModel.endTime)
        }
        
        if createModel.startTime != none && createModel.endTime != none {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
}

// MARK:- Layout

extension BeeCreateTimeViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(toPreviousButton)
        toPreviousButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(12 * DesignSet.frameWidthRatio)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
            $0.width.equalTo(12 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(66 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(timeDescriptionLabel)
        timeDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(203 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(17 * DesignSet.frameHeightRatio)
        }
        view.addSubview(timeSelectStackView)
        timeSelectStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(234 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(22 * DesignSet.frameWidthRatio)
            $0.height.equalTo(54 * DesignSet.frameWidthRatio)
            $0.width.equalTo(290 * DesignSet.frameWidthRatio)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.height.equalTo(56 * DesignSet.frameHeightRatio)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
