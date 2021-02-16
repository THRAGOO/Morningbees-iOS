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
    
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = .autoupdatingCurrent
        return calendar
    }()
    private var currentYear: Int = 0
    private var currentMonth: Int = 0
    private var currentMonthSymbol: String = ""
    private var currentDay: Int = 0
    
    private var todayDate = Date()
    
    private let calendarHeaderLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: 0.43)
        label.textColor = UIColor(red: 68, green: 68, blue: 68)
        label.font = UIFont(font: .systemBold, size: 20)
        return label
    }()
    
    private let prevMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.contentMode = .scaleAspectFit
        let vertical = CGFloat(8 * DesignSet.frameHeightRatio)
        let horizontal = CGFloat(11.5 * DesignSet.frameWidthRatio)
        button.imageEdgeInsets = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        button.addTarget(self, action: #selector(touchupPrevMonth), for: .touchUpInside)
        return button
    }()
    private let nextMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
        button.contentMode = .scaleAspectFit
        let vertical = CGFloat(8 * DesignSet.frameHeightRatio)
        let horizontal = CGFloat(11.5 * DesignSet.frameWidthRatio)
        button.imageEdgeInsets = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        button.addTarget(self, action: #selector(touchupNextMonth), for: .touchUpInside)
        return button
    }()
    
    private let dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let bottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 241, green: 241, blue: 241).cgColor
        return view
    }()
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        return dateFormatter
    }()
    
// MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCalendar()
        setupCalendar()
        setLayout()
    }
}

// MARK:- Calendar

extension CalendarViewController {
    
    private func initCalendar() {
        currentYear = calendar.component(.year, from: Date())
        currentMonth = calendar.component(.month, from: Date())
        currentMonthSymbol = calendar.monthSymbols[currentMonth - 1]
        currentDay = calendar.component(.day, from: Date())
        todayDate = dateFormatter.date(from: "\(currentYear)-\(currentMonth)-\(currentDay)") ?? Date()
        
        for count in 0...6 {
            let label = UILabel()
            label.text = calendar.shortWeekdaySymbols[count]
            label.font = UIFont(font: .systemSemiBold, size: 12)
            label.textAlignment = .center
            if count == 0 {
                label.textColor = UIColor(red: 240, green: 62, blue: 62)
            } else if count == 6 {
                label.textColor = UIColor(red: 34, green: 105, blue: 255)
            } else {
                label.textColor = UIColor(red: 204, green: 204, blue: 204)
            }
            dayOfWeekStackView.addArrangedSubview(label)
        }
    }
    
    private func setupCalendar() {
        for view in dateStackView.arrangedSubviews {
            dateStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        guard let firstDayOfWeek = getFirstDayOfWeek("\(currentYear)-\(currentMonth)-01"),
              let date = dateFormatter.date(from: "\(currentYear)-\(currentMonth)-01"),
              let MonthDays = calendar.range(of: .day, in: .month, for: date)?.count else {
            return
        }
        calendarHeaderLabel.text = "\(currentMonthSymbol) \(currentYear)"
        var dayCount: Int = 1
        
        for weekCount in 1...6 {
            let weekStackView = UIStackView()
            weekStackView.axis = .horizontal
            weekStackView.distribution = .fillEqually
            weekStackView.frame.size = CGSize(width: 273 * DesignSet.frameWidthRatio,
                                              height: 39 * DesignSet.frameWidthRatio)
            if weekCount == 1 {
                for _ in 0 ..< firstDayOfWeek - 1 {
                    let button = UIButton()
                    weekStackView.addArrangedSubview(button)
                }
                for count in firstDayOfWeek...7 {
                    let button = UIButton()
                    button.setTitle("\(dayCount)", for: .normal)
                    if count == 1 {
                        button.setTitleColor(UIColor(red: 240, green: 62, blue: 62), for: .normal)
                    } else if count == 7 {
                        button.setTitleColor(UIColor(red: 34, green: 105, blue: 255), for: .normal)
                    } else {
                        button.setTitleColor(UIColor(red: 119, green: 119, blue: 119), for: .normal)
                    }
                    button.setTitleColor(UIColor(red: 204, green: 204, blue: 204), for: .disabled)
                    button.titleLabel?.font = UIFont(font: .systemSemiBold, size: 13)
                    button.setBackgroundColor(UIColor(red: 217, green: 217, blue: 217), for: .highlighted)
                    button.setBackgroundColor(UIColor(red: 255, green: 218, blue: 34), for: .selected)
                    button.frame.size = CGSize(width: 39 * DesignSet.frameWidthRatio,
                                               height: 39 * DesignSet.frameWidthRatio)
                    button.layer.cornerRadius = button.frame.height / 2
                    button.layer.masksToBounds = true
                    button.addTarget(self, action: #selector(touchupDateButton), for: .touchUpInside)
                    if !isValidDate(dayCount) {
                        button.isEnabled = false
                    }
                    weekStackView.addArrangedSubview(button)
                    dayCount += 1
                }
            } else {
                for count in 1...7 {
                    if dayCount <= MonthDays {
                        let button = UIButton()
                        button.setTitle("\(dayCount)", for: .normal)
                        if count == 1 {
                            button.setTitleColor(UIColor(red: 240, green: 62, blue: 62), for: .normal)
                        } else if count == 7 {
                            button.setTitleColor(UIColor(red: 34, green: 105, blue: 255), for: .normal)
                        } else {
                            button.setTitleColor(UIColor(red: 119, green: 119, blue: 119), for: .normal)
                        }
                        button.titleLabel?.font = UIFont(font: .systemSemiBold, size: 13)
                        button.setTitleColor(UIColor(red: 204, green: 204, blue: 204), for: .disabled)
                        button.setBackgroundColor(UIColor(red: 217, green: 217, blue: 217), for: .highlighted)
                        button.setBackgroundColor(UIColor(red: 255, green: 218, blue: 34), for: .selected)
                        button.frame.size = CGSize(width: 39 * DesignSet.frameWidthRatio,
                                                   height: 39 * DesignSet.frameWidthRatio)
                        button.layer.cornerRadius = button.frame.height / 2
                        button.layer.masksToBounds = true
                        button.addTarget(self, action: #selector(touchupDateButton), for: .touchUpInside)
                        if !isValidDate(dayCount) {
                            button.isEnabled = false
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
        guard let todayDate = dateFormatter.date(from: today) else {
            return nil
        }
        return calendar.component(.weekday, from: todayDate)
    }
    
    private func isValidDate(_ day: Int) -> Bool {
        guard let parameterDate = dateFormatter.date(from: "\(currentYear)-\(currentMonth)-\(day)") else {
            return false
        }
        // 24hours * 60minuates * 60seconds -> 1Day
        if todayDate + (24 * 60 * 60) < parameterDate {
            return false
        }
        return true
    }
}

// MARK:- UX

extension CalendarViewController {
    
    // MARK: Touch Event
    
    @objc private func touchupDateButton(sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
        if let selectedDay = sender.titleLabel?.text {
            let targetDate = dateFormatter.date(from: "\(currentYear)-\(currentMonth)-\(selectedDay)")
            UserDefaults.standard.set(targetDate, forKey: UserDefaultsKey.targetDate.rawValue)
        }
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name.init("ChangeDate"), object: nil)
        }
    }
    
    @objc private func touchupNextMonth(_ sender: UIButton) {
        currentMonth += 1
        if 12 < currentMonth {
            currentMonth = 1
            currentYear += 1
        }
        currentMonthSymbol = calendar.monthSymbols[currentMonth - 1]
        setupCalendar()
    }
    
    @objc private func touchupPrevMonth(_ sender: UIButton) {
        currentMonth -= 1
        if currentMonth < 1 {
            currentMonth = 12
            currentYear -= 1
        }
        currentMonthSymbol = calendar.monthSymbols[currentMonth - 1]
        setupCalendar()
    }
}

// MARK:- Layout

extension CalendarViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        view.addSubview(calendarHeaderLabel)
        calendarHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(21 * DesignSet.frameHeightRatio)
            $0.height.equalTo(24 * DesignSet.frameHeightRatio)
            $0.width.greaterThanOrEqualTo(106 * DesignSet.frameWidthRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
        view.addSubview(prevMonthButton)
        prevMonthButton.snp.makeConstraints {
            $0.height.equalTo(30 * DesignSet.frameHeightRatio)
            $0.width.equalTo(30 * DesignSet.frameWidthRatio)
            $0.centerY.equalTo(calendarHeaderLabel.snp.centerY)
            $0.leading.equalToSuperview().offset(10 * DesignSet.frameWidthRatio)
        }
        view.addSubview(nextMonthButton)
        nextMonthButton.snp.makeConstraints {
            $0.height.equalTo(30 * DesignSet.frameHeightRatio)
            $0.width.equalTo(30 * DesignSet.frameWidthRatio)
            $0.centerY.equalTo(calendarHeaderLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-10 * DesignSet.frameWidthRatio)
        }
        
        view.addSubview(dayOfWeekStackView)
        dayOfWeekStackView.snp.makeConstraints {
            $0.top.equalTo(72 * DesignSet.frameHeightRatio)
            $0.height.equalTo(14 * DesignSet.frameHeightRatio)
            $0.width.greaterThanOrEqualTo(273 * DesignSet.frameWidthRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
        view.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(95 * DesignSet.frameHeightRatio)
            $0.height.equalTo(1 * DesignSet.frameHeightRatio)
            $0.width.greaterThanOrEqualTo(260 * DesignSet.frameWidthRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
        view.addSubview(dateStackView)
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(98 * DesignSet.frameHeightRatio)
            $0.height.greaterThanOrEqualTo(234 * DesignSet.frameWidthRatio)
            $0.width.greaterThanOrEqualTo(273 * DesignSet.frameWidthRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
}
