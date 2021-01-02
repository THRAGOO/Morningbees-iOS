//
//  CalendarViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/08/07.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class CalendarViewController: UIViewController {
    
// MARK:- Properties
    
    private var MonthDays: [Int] = [ 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
    private let myCalendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = .autoupdatingCurrent
        return calendar
    }()
    private var currentYear: Int = 0
    private var currentMonth: Int = 0
    private var currentMonthSymbol: String = ""
    private var currentDay: Int = 0
    
    private let calendarHeaderLabel: UILabel = {
        let label = DesignSet.initLabel(text: "", letterSpacing: 0.43)
        label.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 20)
        return label
    }()
    
    private let prevMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(touchupPrevMonth), for: .touchUpInside)
        return button
    }()
    private let nextMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
        button.addTarget(self, action: #selector(touchupNextMonth), for: .touchUpInside)
        return button
    }()
    
    private let dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    private let bottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = DesignSet.colorSet(red: 241, green: 241, blue: 241).cgColor
        return view
    }()
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
// MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCalendar()
        setupCalendar()
        setupDesign()
    }
}

// MARK:- Calendar

extension CalendarViewController {
    
    private func initCalendar() {
        currentYear = myCalendar.component(.year, from: Date())
        currentMonth = myCalendar.component(.month, from: Date())
        currentMonthSymbol = myCalendar.monthSymbols[currentMonth - 1]
        currentDay = myCalendar.component(.day, from: Date())
        
        for count in 0...6 {
            let label = UILabel()
            label.text = myCalendar.shortWeekdaySymbols[count]
            label.font = DesignSet.fontSet(name: TextFonts.systemSemiBold.rawValue, size: 12)
            label.textAlignment = .center
            if count == 0 {
                label.textColor = DesignSet.colorSet(red: 240, green: 62, blue: 62)
            } else if count == 6 {
                label.textColor = DesignSet.colorSet(red: 34, green: 105, blue: 255)
            } else {
                label.textColor = DesignSet.colorSet(red: 204, green: 204, blue: 204)
            }
            dayOfWeekStackView.addArrangedSubview(label)
        }
    }
    
    private func setupCalendar() {
        for view in dateStackView.arrangedSubviews {
            dateStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        guard let firstDayOfWeek = getFirstDayOfWeek("\(currentYear)-\(currentMonth)-01") else {
            return
        }
        
        calendarHeaderLabel.text = "\(currentMonthSymbol) \(currentYear)"
        
        // Consider Lunar Year
        if currentYear % 4 == 0 {
            if currentYear % 100 == 0 {
                if currentYear % 400 == 0 {
                    MonthDays[2] = 29
                } else {
                    MonthDays[2] = 28
                }
            } else {
                MonthDays[2] = 29
            }
        } else {
            MonthDays[2] = 28
        }
        
        var dayCount: Int = 1
        
        for weekCount in 1...6 {
            let weekStackView = UIStackView()
            weekStackView.alignment = .fill
            weekStackView.axis = .horizontal
            weekStackView.distribution = .fillEqually
            
            if weekCount == 1 {
                for _ in 0 ..< firstDayOfWeek - 1 {
                    let button = UIButton()
                    weekStackView.addArrangedSubview(button)
                }
                for count in firstDayOfWeek...7 {
                    let button = UIButton()
                    button.addTarget(self, action: #selector(touchupDateButton), for: .touchUpInside)
                    button.setTitle("\(dayCount)", for: .normal)
                    button.titleLabel?.font = DesignSet.fontSet(name: TextFonts.systemSemiBold.rawValue,
                                                                size: 13)
                    button.layer.cornerRadius = button.bounds.size.height / 2.0
                    button.setBackgroundColor(DesignSet.colorSet(red: 217, green: 217, blue: 217), for: .highlighted)
                    button.setBackgroundColor(DesignSet.colorSet(red: 255, green: 218, blue: 34), for: .selected)
                    if count == 1 {
                        button.setTitleColor(DesignSet.colorSet(red: 240, green: 62, blue: 62), for: .normal)
                    } else if count == 7 {
                        button.setTitleColor(DesignSet.colorSet(red: 34, green: 105, blue: 255), for: .normal)
                    } else {
                        button.setTitleColor(DesignSet.colorSet(red: 119, green: 119, blue: 119), for: .normal)
                    }
                    weekStackView.addArrangedSubview(button)
                    dayCount += 1
                }
            } else {
                for count in 1...7 {
                    if dayCount <= MonthDays[currentMonth] {
                        let button = UIButton()
                        button.addTarget(self, action: #selector(touchupDateButton), for: .touchUpInside)
                        button.setTitle("\(dayCount)", for: .normal)
                        button.titleLabel?.font = DesignSet.fontSet(name: TextFonts.systemSemiBold.rawValue,
                                                                    size: 13)
                        button.setBackgroundColor(DesignSet.colorSet(red: 217, green: 217, blue: 217),
                                                  for: .highlighted)
                        button.setBackgroundColor(DesignSet.colorSet(red: 255, green: 218, blue: 34), for: .selected)
                        if count == 1 {
                            button.setTitleColor(DesignSet.colorSet(red: 240, green: 62, blue: 62), for: .normal)
                        } else if count == 7 {
                            button.setTitleColor(DesignSet.colorSet(red: 34, green: 105, blue: 255), for: .normal)
                        } else {
                            button.setTitleColor(DesignSet.colorSet(red: 119, green: 119, blue: 119), for: .normal)
                        }
                        weekStackView.addArrangedSubview(button)
                        dayCount += 1
                    } else {
                        let button = UIButton()
                        weekStackView.addArrangedSubview(button)
                    }
                }
            }
            dateStackView.addArrangedSubview(weekStackView)
        }
    }
    
    private func getFirstDayOfWeek(_ today: String) -> Int? {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        guard let todayDate = formatter.date(from: today) else {
            return nil
        }
        return myCalendar.component(.weekday, from: todayDate)
    }
    
    @objc private func touchupNextMonth(_ sender: UIButton) {
        currentMonth += 1
        if 12 < currentMonth {
            currentMonth = 1
            currentYear += 1
        }
        currentMonthSymbol = myCalendar.monthSymbols[currentMonth - 1]
        setupCalendar()
    }
    @objc private func touchupPrevMonth(_ sender: UIButton) {
        currentMonth -= 1
        if currentMonth < 1 {
            currentMonth = 12
            currentYear -= 1
        }
        currentMonthSymbol = myCalendar.monthSymbols[currentMonth - 1]
        setupCalendar()
    }
}

// MARK:- UX

extension CalendarViewController {
    
    @objc private func touchupDateButton(sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
        if let selectedDate = sender.titleLabel?.text {
            UserDefaults.standard.set("\(currentYear)-\(currentMonth)-\(selectedDate)", forKey: "missionDate")
        }
        BeeMainViewController.updateDateLabel()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- View Design

extension CalendarViewController {
    
    private func setupDesign() {
        view.addSubview(calendarHeaderLabel)
        view.addSubview(prevMonthButton)
        view.addSubview(nextMonthButton)
        
        view.addSubview(dayOfWeekStackView)
        view.addSubview(bottomlineView)
        view.addSubview(dateStackView)
        
        calendarHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(21 * DesignSet.frameHeightRatio)
            $0.height.equalTo(24 * DesignSet.frameHeightRatio)
            $0.width.greaterThanOrEqualTo(106 * DesignSet.frameWidthRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        prevMonthButton.snp.makeConstraints {
            $0.height.equalTo(14 * DesignSet.frameHeightRatio)
            $0.width.equalTo(7 * DesignSet.frameWidthRatio)
            $0.centerY.equalTo(calendarHeaderLabel.snp.centerY)
            $0.leading.equalToSuperview().offset(27 * DesignSet.frameWidthRatio)
        }
        nextMonthButton.snp.makeConstraints {
            $0.height.equalTo(14 * DesignSet.frameHeightRatio)
            $0.width.equalTo(7 * DesignSet.frameWidthRatio)
            $0.centerY.equalTo(calendarHeaderLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-31 * DesignSet.frameWidthRatio)
        }
        
        dayOfWeekStackView.snp.makeConstraints {
            $0.top.equalTo(72 * DesignSet.frameHeightRatio)
            $0.height.equalTo(14 * DesignSet.frameHeightRatio)
            $0.width.greaterThanOrEqualTo(271 * DesignSet.frameWidthRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(95 * DesignSet.frameHeightRatio)
            $0.height.equalTo(1 * DesignSet.frameHeightRatio)
            $0.width.greaterThanOrEqualTo(260 * DesignSet.frameWidthRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(96 * DesignSet.frameHeightRatio)
            $0.height.equalTo(240 * DesignSet.frameHeightRatio)
            $0.width.greaterThanOrEqualTo(271 * DesignSet.frameWidthRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
}
