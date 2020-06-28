//
//  BeeCreateTimeViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/13.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

enum TimeButtonState {
    case start
    case end
}

final class BeeCreateTimeViewController: UIViewController {
    
    //MARK:- Properties
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(popToPrevious), for: .touchUpInside)
        return button
    }()
    private let helpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconQuestionMark"), for: .normal)
        return button
    }()
    
    private let firstDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "미션 수행 시간을", letterSpacing: -0.5)
        label.textColor = DesignSet.colorSet(red: 34, green: 34, blue: 34)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoMedium.rawValue, size: 24)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let secondDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "선택해 주세요.", letterSpacing: -0.5)
        label.textColor = DesignSet.colorSet(red: 34, green: 34, blue: 34)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoMedium.rawValue, size: 24)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let timeDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "시작 및 종료 시간", letterSpacing: 0)
        label.textColor = DesignSet.colorSet(red: 119, green: 119, blue: 119)
        label.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoMedium.rawValue, size: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSet.colorSet(red: 229, green: 229, blue: 229)
        button.isEnabled = false
        button.setTitle("다음 2/3", for: .normal)
        button.setTitleColor(DesignSet.colorSet(red: 255, green: 255, blue: 255), for: .normal)
        button.titleLabel?.font =  DesignSet.fontSet(name: TextFonts.appleSDGothicNeoSemiBold.rawValue, size: 15)
        button.addTarget(self, action: #selector(touchUpNextButton), for: .touchUpInside)
        return button
    }()
    
    private var timeButtons = [UIButton]()
    private let timeSelectStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let beeYellow = DesignSet.colorSet(red: 255, green: 218, blue: 34)
    private let timeButtonDisabled = DesignSet.colorSet(red: 249, green: 249, blue: 249)
    
    private var startTime: Int = 0
    private var endTime: Int = 0
    var beeName: String = ""
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupButton()
    }
}

//MARK:- Segue and Navigation

extension BeeCreateTimeViewController {
    
    @objc private func touchUpNextButton() {
        performSegue(withIdentifier: "pushToStepJelly", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let beeCreateJellyViewController = segue.destination as? BeeCreateJellyViewController else {
            return
        }
        beeCreateJellyViewController.beeName = self.beeName
        beeCreateJellyViewController.startTime = self.startTime
        beeCreateJellyViewController.endTime = self.endTime
    }
    
    @objc private func popToPrevious(_ sender: UIButton) {
        NavigationControl().popToPrevViewController()
    }
}

//MARK:- Mission Time Button Set

extension BeeCreateTimeViewController {
    
    private func setupButton() {
        for idx in 0..<5 {
            let button = UIButton()
            button.backgroundColor = timeButtonDisabled
            button.setBackgroundImage(UIImage(named: "btnTimeOutline"), for: .normal)
            button.setBackgroundImage(UIImage(named: "btnTimeOutline"), for: .highlighted)
            button.setBackgroundImage(UIImage(named: "btnTimeOutline"), for: [.selected, .highlighted])
            timeSelectStackView.addArrangedSubview(button)
            timeButtons.append(button)
            
            button.setTitle(String(idx + 6), for: .normal)
            button.setTitleColor(DesignSet.colorSet(red: 68, green: 68, blue: 68), for: .normal)
            button.titleLabel?.font = DesignSet.fontSet(name: TextFonts.appleSDGothicNeoSemiBold.rawValue, size: 16)
            button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setupButtonLabel(_ state: TimeButtonState) {
        nextButton.setTitleColor(DesignSet.colorSet(red: 255, green: 255, blue: 255), for: .normal)
        if state == .start {
            nextButton.setTitle("미션 시작시간을 선택해 주세요.", for: .normal)
        } else if state == .end {
            nextButton.setTitle("미션 종료시간을 선택해 주세요.", for: .normal)
        }
    }
    
    private func timeButtonSelected(_ state: Bool, _ index: Int) {
        timeButtons[index].isSelected = state ? true : false
        switch index {
        case 0:
            let enableColor = DesignSet.colorSet(red: 255, green: 239, blue: 142)
            timeButtons[index].backgroundColor = state ? enableColor : timeButtonDisabled
        case 1:
            let enableColor = DesignSet.colorSet(red: 255, green: 226, blue: 81)
            timeButtons[index].backgroundColor = state ? enableColor : timeButtonDisabled
        case 2:
            let enableColor = DesignSet.colorSet(red: 251, green: 201, blue: 50)
            timeButtons[index].backgroundColor = state ? enableColor : timeButtonDisabled
        case 3:
            let enableColor = DesignSet.colorSet(red: 242, green: 159, blue: 6)
            timeButtons[index].backgroundColor = state ? enableColor : timeButtonDisabled
        case 4:
            let enableColor = DesignSet.colorSet(red: 238, green: 128, blue: 7)
            timeButtons[index].backgroundColor = state ? enableColor : timeButtonDisabled
        default:
            break
        }
    }
    
    @objc private func ratingButtonTapped(button: UIButton) {
        guard let index = timeButtons.firstIndex(of: button) else {
            return
        }
        let selectedTime = index + 6
        
        if startTime == 0 && timeButtons[index].isSelected == false {
            startTime = selectedTime
            timeButtonSelected(true, index)
            if startTime == 10 {
                setupButtonLabel(.start)
            } else {
                setupButtonLabel(.end)
            }
        } else if endTime == 0 && timeButtons[index].isSelected == false {
            endTime = selectedTime
            timeButtonSelected(true, index)
        } else if startTime == selectedTime || endTime == selectedTime {
            if startTime == selectedTime {
                startTime = 0
                setupButtonLabel(.start)
            } else {
                endTime = 0
                if startTime == 0 && endTime == 0 {
                    setupButtonLabel(.start)
                } else {
                    setupButtonLabel(.end)
                }
            }
            timeButtonSelected(false, index)
        }
        
        if startTime > endTime {
            let tmp = startTime
            startTime = endTime
            endTime = tmp
        }
        
        if startTime != 0 && endTime != 0 {
            nextButton.isEnabled = true
            nextButton.backgroundColor = beeYellow
            nextButton.setTitle("다음 2/3", for: .normal)
            nextButton.setTitleColor(DesignSet.colorSet(red: 34, green: 34, blue: 34), for: .normal)
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = DesignSet.colorSet(red: 229, green: 229, blue: 229)
        }
    }
}

//MARK:- Design

extension BeeCreateTimeViewController {
    
    func setupDesign() {
        view.addSubview(toPreviousButton)
        view.addSubview(helpButton)
        
        view.addSubview(firstDescriptionLabel)
        view.addSubview(secondDescriptionLabel)
        
        view.addSubview(timeDescriptionLabel)
        view.addSubview(timeSelectStackView)
        view.addSubview(nextButton)
        
        DesignSet.constraints(view: toPreviousButton, top: 42, leading: 24, height: 20, width: 12)
        DesignSet.constraints(view: helpButton, top: 42, leading: 331, height: 20, width: 20)
        
        DesignSet.constraints(view: firstDescriptionLabel, top: 90, leading: 24, height: 33, width: 174)
        DesignSet.constraints(view: secondDescriptionLabel, top: 123, leading: 24, height: 33, width: 174)
        
        DesignSet.constraints(view: timeDescriptionLabel, top: 223, leading: 24, height: 17, width: 96)
        DesignSet.squareConstraints(view: timeSelectStackView, top: 255, leading: 20, height: 54, width: 290)
        DesignSet.constraints(view: nextButton, top: 611, leading: 0, height: 56, width: 375)
    }
}
