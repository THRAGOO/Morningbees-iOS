//
//  BeeCreateTimeViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/13.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class BeeCreateTimeViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet private weak var beeNameLabel: UILabel!
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(touchUpNextButton), for: .touchUpInside)
        return button
    }()
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "다음 2/3"
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var timeButtons = [UIButton]()
    private let timeSelectStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 6
        return stackView
    }()
    private var startTime: Int = 0
    private var endTime: Int = 0
    
    var beeName: String = ""
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setUpButton()
        beeNameLabel.text = beeName
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
    
    @IBAction private func popToPrevious(_ sender: UIButton) {
        NavigationControl().popToPrevViewController()
    }
}

//MARK:- Mission Time Button Set

extension BeeCreateTimeViewController {
    
    private func setUpButton() {
        for idx in 0..<5 {
            let button = UIButton()
            button.backgroundColor = .lightGray
            button.layer.cornerRadius = 10
            timeSelectStackView.addArrangedSubview(button)
            timeButtons.append(button)
            
            let label = UILabel()
            label.text = String(idx + 6)
            label.textAlignment = .center
            button.addSubview(label)
            button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchUpInside)
            
            button.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.width.equalTo(63)
            }
            DesignSet.constraints(view: label, top: 15, leading: 20, height: 24, width: 23)
        }
    }
    
    private func setupButtonLable(_ state: String) {
        buttonLabel.textColor = .white
        if state == "Start" {
            buttonLabel.text = "미션 시작시간을 선택해 주세요."
        } else if state == "End" {
            buttonLabel.text = "미션 종료시간을 선택해 주세요."
        }
    }
    
    private func timeButtonSelected(_ state: Bool, _ index: Int) {
        if state {
            timeButtons[index].isSelected = true
            timeButtons[index].backgroundColor = .yellow
        } else {
            timeButtons[index].isSelected = false
            timeButtons[index].backgroundColor = .lightGray
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
                setupButtonLable("Start")
            } else {
                setupButtonLable("End")
            }
        } else if endTime == 0 && timeButtons[index].isSelected == false {
            endTime = selectedTime
            timeButtonSelected(true, index)
        } else if startTime == selectedTime || endTime == selectedTime {
            if startTime == selectedTime {
                startTime = 0
                setupButtonLable("Start")
            } else {
                endTime = 0
                if startTime == 0 && endTime == 0 {
                    setupButtonLable("Start")
                } else {
                    setupButtonLable("End")
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
            nextButton.backgroundColor = .yellow
            buttonLabel.text = "다음 2/3"
            buttonLabel.textColor = .black
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .lightGray
        }
    }
}

//MARK:- Design

extension BeeCreateTimeViewController {
    
    func setDesign() {
        view.addSubview(timeSelectStackView)
        view.addSubview(nextButton)
        nextButton.addSubview(buttonLabel)
        
        DesignSet.constraints(view: timeSelectStackView, top: 265, leading: 20, height: 54, width: 339)
        DesignSet.constraints(view: nextButton, top: 611, leading: 0, height: 56, width: 375)
        DesignSet.constraints(view: buttonLabel, top: 19, leading: 88, height: 19, width: 200)
    }
}
