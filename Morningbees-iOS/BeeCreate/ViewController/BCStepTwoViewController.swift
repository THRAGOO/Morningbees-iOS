//
//  BCStepTwoViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/13.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

class BCStepTwoViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet private weak var beeNameLabel: UILabel!
    
    private let nextBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(touchUpNextBtn), for: .touchUpInside)
        return button
    }()
    private let btnLabel: UILabel = {
        let label = UILabel()
        label.text = "다음 2/3"
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var timeBtn = [UIButton]()
    private let timeSelect: UIStackView = {
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
        setUpBtn()
        beeNameLabel.text = beeName
    }
}

//MARK:- Segue and Navigation

extension BCStepTwoViewController {
    
    @objc private func touchUpNextBtn() {
        performSegue(withIdentifier: "pushToStepThr", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let bcStepThrViewController = segue.destination as? BCStepThrViewController else {
            return
        }
        bcStepThrViewController.beeName = self.beeName
        bcStepThrViewController.startTime = self.startTime
        bcStepThrViewController.endTime = self.endTime
    }
    
    @IBAction private func popToPrevious(_ sender: UIButton) {
        NavigationControl().popToPrevViewController()
    }
}

//MARK:- Mission Time Button Set

extension BCStepTwoViewController {
    
    private func setUpBtn() {
        for idx in 0..<5 {
            let button = UIButton()
            button.backgroundColor = .lightGray
            button.layer.cornerRadius = 10
            timeSelect.addArrangedSubview(button)
            timeBtn.append(button)
            
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
    
    private func setupBtnLable(_ state: String) {
        btnLabel.textColor = .white
        if state == "Start" {
            btnLabel.text = "미션 시작시간을 선택해 주세요."
        } else if state == "End" {
            btnLabel.text = "미션 종료시간을 선택해 주세요."
        }
    }
    
    private func timeBtnSelected(_ state: Bool, _ index: Int) {
        if state {
            timeBtn[index].isSelected = true
            timeBtn[index].backgroundColor = .yellow
        } else {
            timeBtn[index].isSelected = false
            timeBtn[index].backgroundColor = .lightGray
        }
    }
    
    @objc private func ratingButtonTapped(button: UIButton) {
        guard let index = timeBtn.firstIndex(of: button) else {
            return
        }
        let selectedTime = index + 6
        
        if startTime == 0 && timeBtn[index].isSelected == false {
            startTime = selectedTime
            timeBtnSelected(true, index)
            if startTime == 10 {
                setupBtnLable("Start")
            } else {
                setupBtnLable("End")
            }
        } else if endTime == 0 && timeBtn[index].isSelected == false {
            endTime = selectedTime
            timeBtnSelected(true, index)
        } else if startTime == selectedTime || endTime == selectedTime {
            if startTime == selectedTime {
                startTime = 0
                setupBtnLable("Start")
            } else {
                endTime = 0
                if startTime == 0 && endTime == 0 {
                    setupBtnLable("Start")
                } else {
                    setupBtnLable("End")
                }
            }
            timeBtnSelected(false, index)
        }
        
        if startTime > endTime {
            let tmp = startTime
            startTime = endTime
            endTime = tmp
        }
        
        if startTime != 0 && endTime != 0 {
            nextBtn.isEnabled = true
            nextBtn.backgroundColor = .yellow
            btnLabel.text = "다음 2/3"
            btnLabel.textColor = .black
        } else {
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = .lightGray
        }
    }
}

//MARK:- Design

extension BCStepTwoViewController {
    
    func setDesign() {
        view.addSubview(timeSelect)
        view.addSubview(nextBtn)
        nextBtn.addSubview(btnLabel)
        
        DesignSet.constraints(view: timeSelect, top: 265, leading: 20, height: 54, width: 339)
        DesignSet.constraints(view: nextBtn, top: 611, leading: 0, height: 56, width: 375)
        DesignSet.constraints(view: btnLabel, top: 19, leading: 88, height: 19, width: 200)
    }
}
