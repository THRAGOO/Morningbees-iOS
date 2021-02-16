//
//  BeeMainViewController.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2020/02/15.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Firebase
import Kingfisher
import UIKit
import Lottie

final class BeeMainViewController: UIViewController, CustomAlert {
    
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
        let label = UILabel(text: "모임 정보 요청 중...", letterSpacing: 0)
        label.textColor = .white
        label.font = UIFont(font: .systemBold, size: 24)
        return label
    }()
    
    private let mainBackgroundImageView = UIImageView(imageName: "mainBg")
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .white
        scrollView.contentSize.height = CGFloat(918 * DesignSet.frameHeightRatio)
        scrollView.setRatioCornerRadius(30)
        scrollView.layer.masksToBounds = true
        return scrollView
    }()
    
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "iconSettings"), for: .normal)
        button.alpha = 0.5
        button.addTarget(self, action: #selector(touchupSettingButton), for: .touchUpInside)
        return button
    }()
    
    private let beeTitleLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: -0.6)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        label.font = UIFont(font: .systemBold, size: 26)
        label.numberOfLines = 0
        return label
    }()
    private let memberCountLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: -0.58)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemSemiBold, size: 13)
        return label
    }()
    
    private let wonImageView = UIImageView(imageName: "oval")
    private let jellyDescriptionLabel: UILabel = {
        let label = UILabel(text: "총 누적 젤리", letterSpacing: -0.5)
        label.textColor = UIColor(red: 68, green: 68, blue: 68)
        label.font = UIFont(font: .systemMedium, size: 14)
        return label
    }()
    private let totalJelly: UILabel = {
        let label = UILabel(text: "", letterSpacing: -0.5)
        label.textColor = UIColor(red: 68, green: 68, blue: 68)
        label.font = UIFont(font: .systemSemiBold, size: 15)
        return label
    }()
    private let jellyReceiptButton: UIButton = {
        let button = UIButton()
        button.setTitle("내역 확인", for: .normal)
        button.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .normal)
        button.titleLabel?.font = UIFont(font: .systemMedium, size: 12)
        button.setRatioCornerRadius(13.5)
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 234, green: 234, blue: 234).cgColor
        return button
    }()
    
    private let missionTimeDescriptionLabel: UILabel = {
        let label = UILabel(text: "미션 시간", letterSpacing: -0.62)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemMedium, size: 13)
        return label
    }()
    private let toBeDeterminedTimeView: UIView = {
        let view = UIView()
        view.setRatioCornerRadius(27)
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(red: 246, green: 245, blue: 242)
        return view
    }()
    private let missionTimeAnimationView: AnimationView = {
        let view = AnimationView()
        view.animation = Animation.named("Lottie_mission_time")
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        return view
    }()
    private let missionTimeLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: -0.5)
        label.textColor = .white
        label.font = UIFont(font: .systemBold, size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let todayQuestionerDescriptionLabel: UILabel = {
        let label = UILabel(text: "오늘의 꿀벌", letterSpacing: -0.62)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemMedium, size: 13)
        return label
    }()
    private let todayQuestionerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor(red: 246, green: 245, blue: 242)
        view.setRatioCornerRadius(22.5)
        view.layer.masksToBounds = true
        return view
    }()
    private let todayQuestionerNicknameLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: -0.3)
        label.textColor = UIColor(red: 68, green: 68, blue: 68)
        label.font = UIFont(font: .systemBold, size: 12)
        return label
    }()
    private let nextQuestionerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor(red: 236, green: 235, blue: 232)
        view.setRatioCornerRadius(15)
        view.layer.masksToBounds = true
        return view
    }()
    
    private let difficultyDescriptionLabel: UILabel = {
        let label = UILabel(text: "난이도", letterSpacing: -0.62)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemMedium, size: 13)
        return label
    }()
    private let difficultyImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let toBeDeterminedDifficultyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 246, green: 245, blue: 242)
        view.setRatioCornerRadius(27)
        view.layer.masksToBounds = true
        return view
    }()
    private let toBeDeterminedDifficultyLabel: UILabel = {
        let label = UILabel(text: "미정", letterSpacing: -0.6)
        label.textColor = UIColor(red: 204, green: 204, blue: 204)
        label.font = UIFont(font: .systemSemiBold, size: 15)
        return label
    }()
    
    private let dateFormatterForTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H"
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        return dateFormatter
    }()
    private let dateFormatterForLabel: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        return dateFormatter
    }()
    private let dateLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: 0.0)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemSemiBold, size: 13)
        label.textAlignment = .right
        return label
    }()
    private let calendarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconCalendar"), for: .normal)
        button.alpha = 0.5
        button.addTarget(self, action: #selector(touchupCalendarButton), for: .touchUpInside)
        return button
    }()
    
    private let todaysMissionDescriptionLabel: UILabel = {
        let label = UILabel(text: "오늘의 미션 사진", letterSpacing: -0.6)
        label.textColor = UIColor(red: 68, green: 68, blue: 68)
        label.font = UIFont(font: .systemBold, size: 20)
        return label
    }()
    private let missionImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor(red: 248, green: 248, blue: 248)
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    private let missionBlurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        return blurView
    }()
    private let shadowMissionView: UIView = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 15)
        return view
    }()
    private let missionNotPostedLabel: UILabel = {
        let label = UILabel(text: "미션이 등록되지 않았습니다.", letterSpacing: -0.6)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemBold, size: 16)
        return label
    }()
    private let missionDescriptionLabel: UILabel = {
        let label = UILabel(text: "오늘의 미션", letterSpacing: -0.6)
        label.textColor = .white
        label.font = UIFont(font: .systemBold, size: 14)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        return label
    }()
    private let missionTitleLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: -0.6)
        label.textColor = .white
        label.font = UIFont(font: .systemBold, size: 24)
        label.numberOfLines = 0
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        return label
    }()
    private let createMissionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "participateInMission"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchupCreateMissionButton), for: .touchUpInside)
        return button
    }()
    
    private let participatedMissionDescriptionLabel: UILabel = {
        let label = UILabel(text: "미션 참여사진", letterSpacing: -0.6)
        label.textColor = UIColor(red: 68, green: 68, blue: 68)
        label.font = UIFont(font: .systemBold, size: 20)
        return label
    }()
    private let participantsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        return scrollView
    }()
    private let participateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 248, green: 248, blue: 248)
        button.contentMode = .center
        button.setRatioCornerRadius(18)
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(touchupSubmitMissionButton), for: .touchUpInside)
        let buttonWidth = 126 * DesignSet.frameWidthRatio
        let buttonHeight = 174 * DesignSet.frameHeightRatio
        button.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        let dashBorder = CAShapeLayer()
        dashBorder.strokeColor = UIColor(red: 221, green: 221, blue: 221).cgColor
        dashBorder.fillColor = nil
        dashBorder.lineDashPattern = [3, 2]
        dashBorder.frame = button.bounds
        let cornerRadius = CGFloat(18 * DesignSet.frameHeightRatio)
        dashBorder.path = UIBezierPath(roundedRect: button.bounds, cornerRadius: cornerRadius).cgPath
        button.layer.addSublayer(dashBorder)
        return button
    }()
    private let participateImage = UIImageView(imageName: "participateMission")
    private let participateLabel: UILabel = {
        let label = UILabel(text: "미션 참여사진\n업로드", letterSpacing: -0.3)
        label.textColor = UIColor(red: 204, green: 204, blue: 204)
        label.font = UIFont(font: .systemBold, size: 13)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    private let toMissionListButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "moreMissionPhoto"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchupMissionListButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Data Container
    
    private var missions: [Missions]?
    private var beeInfo: BeeInfos?
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScrollView.delegate = self
        requestMain(changeDate: false)
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissSubView),
                                               name: Notification.Name.init("DismissSubmitView"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeDate),
                                               name: Notification.Name.init("ChangeDate"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(takePhotoFromCamera),
                                               name: Notification.Name.init("MissionCamera"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(takePhotoFromLibrary),
                                               name: Notification.Name.init("MissionPhoto"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(touchupSubmitMissionButton),
                                               name: Notification.Name.init("ReloadPhoto"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewDidLoad),
                                               name: Notification.Name.init("ReloadViewController"),
                                               object: nil)
        missionTimeAnimationView.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("DismissSubmitView"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("ChangeDate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("MissionCamera"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("MissionPhoto"), object: nil)
    }
}

// MARK:- ScrollView Control

extension BeeMainViewController: UIScrollViewDelegate {
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y.isLessThanOrEqualTo(CGFloat(-50.0 * DesignSet.frameHeightRatio)) {
            UIView.animate(withDuration: 0.5) { [self] in
                scrollView.transform = .identity
                scrollView.isScrollEnabled = false
                hideJellyView(false)
            } completion: { _ in
                scrollView.isScrollEnabled = true
            }
        } else if view.frame.minY < scrollView.frame.minY {
            UIView.animate(withDuration: 0.5) { [self] in
                let y = scrollView.frame.minY + CGFloat(30 * DesignSet.frameHeightRatio)
                scrollView.transform = CGAffineTransform(translationX: 0, y: -y)
                scrollView.isScrollEnabled = false
                hideJellyView(true)
            } completion: { _ in
                scrollView.isScrollEnabled = true
            }
        }
    }
}

// MARK:- UI

extension BeeMainViewController {
    
    private func hideJellyView(_ setHide: Bool) {
        if setHide {
            wonImageView.alpha = 0
            jellyDescriptionLabel.alpha = 0
            totalJelly.alpha = 0
            jellyReceiptButton.alpha = 0
        } else {
            wonImageView.alpha = 1
            jellyDescriptionLabel.alpha = 1
            totalJelly.alpha = 1
            jellyReceiptButton.alpha = 1
        }
    }
    
    // MARK: Bee Info Setup
    
    private func setupBeeInfo() {
        guard let beeInfo = beeInfo else {
            return
        }
        let myNickname = UserDefaults.standard.string(forKey: UserDefaultsKey.myNickname.rawValue)
        let isQueenBee = myNickname == beeInfo.manager.nickname ? true: false
        UserDefaults.standard.set(beeInfo.title, forKey: UserDefaultsKey.beeTitle.rawValue)
        UserDefaults.standard.set(beeInfo.manager.nickname, forKey: UserDefaultsKey.queenBee.rawValue)
        UserDefaults.standard.set(isQueenBee, forKey: UserDefaultsKey.isQueenBee.rawValue)
        
        beeTitleLabel.text = beeInfo.title
        memberCountLabel.text = "전체멤버 \(beeInfo.memberCounts)"
        totalJelly.text = "\(beeInfo.totalPenalty)원"
        missionTimeLabel.text = "\(beeInfo.startTime)-\(beeInfo.endTime)"
        
        missionTimeAnimationView.isHidden = !isSubmitMissionTime()
        toBeDeterminedTimeView.isHidden = isSubmitMissionTime()
        
        todayQuestionerImageView.setImage(with: beeInfo.todayQuestioner.profileImage)
        nextQuestionerImageView.setImage(with: beeInfo.nextQuestioner.profileImage)
        todayQuestionerNicknameLabel.text = beeInfo.todayQuestioner.nickname
        
        toBeDeterminedDifficultyView.isHidden = true
        difficultyImageView.isHidden = false
        switch beeInfo.todayDifficulty {
        case 0:
            difficultyImageView.image = UIImage(named: "lowLevel")
        case 1:
            difficultyImageView.image = UIImage(named: "middleLevel")
        case 2:
            difficultyImageView.image = UIImage(named: "highLevel")
        default:
            difficultyImageView.isHidden = true
            toBeDeterminedDifficultyView.isHidden = false
        }
    }
    
    // MARK: Mission Setup
    
    private func setupMissions() {
        clearSubViews(participantsScrollView)
        removeViewDashBorder(at: missionImageView)
        controlMissionView(mission: false)
        
        if !didSubmitMission() && isCreateMissionTime() &&
            ((isNextQuestioner() && getPresentedTargetView() == .tomorrow) ||
                (isTodayQuestioner() && getPresentedTargetView() == .today)) {
            missionNotPostedLabel.text = "미션을 등록해 주세요."
            addViewDashBorder(at: missionImageView)
            createMissionButton.isHidden = false
        } else {
            missionNotPostedLabel.text = "미션이 등록되지 않았습니다."
            createMissionButton.isHidden = true
        }
        
        guard let missions = missions, missions.first != nil else {
            return
        }
        for mission in missions {
            if mission.type == 1 {
                if getPresentedTargetView() == .tomorrow {
                    missionBlurView.isHidden = false
                    missionTitleLabel.text = "자정 이후에 공개됩니다."
                } else {
                    missionBlurView.isHidden = true
                    missionTitleLabel.text = mission.missionTitle
                }
                missionImageView.setImage(with: mission.imageUrl)
                controlMissionView(mission: true)
                break
            }
        }
        
        var submittedCount = 0.0
        if !didSubmitMission() && isSubmitMissionTime() && getPresentedTargetView() == .today {
            participantsScrollView.addSubview(participateButton)
            participantsScrollView.contentSize.width = participateButton.frame.width
            submittedCount += 1
        }
        for mission in missions {
            if mission.type == 2 {
                let imageView = UIImageView()
                imageView.setImage(with: mission.imageUrl)
                imageView.contentMode = .scaleAspectFill
                imageView.setRatioCornerRadius(18)
                imageView.clipsToBounds = true
                let xPosition = 135 * DesignSet.frameWidthRatio * submittedCount
                let imageWidth = 126 * DesignSet.frameWidthRatio
                let imageHeight = 174 * DesignSet.frameHeightRatio
                imageView.frame = CGRect(x: xPosition, y: 0, width: imageWidth, height: imageHeight)
                participantsScrollView.addSubview(imageView)
                let scrollViewSize = CGFloat(135 * DesignSet.frameWidthRatio * (submittedCount + 1))
                participantsScrollView.contentSize.width = scrollViewSize
                submittedCount += 1
                if 2 < submittedCount {
                    break
                }
            }
        }
        if (didSubmitMission() && 0 < submittedCount) || (!didSubmitMission() && 1 < submittedCount) {
            let buttonX = Double(participantsScrollView.contentSize.width)
            let buttonY = 63 * DesignSet.frameHeightRatio
            let buttonWidth = 48 * DesignSet.frameHeightRatio
            toMissionListButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonWidth)
            participantsScrollView.addSubview(toMissionListButton)
            participantsScrollView.contentSize.width += CGFloat(70 * DesignSet.frameWidthRatio)
        }
    }
    
    private func clearSubViews(_ view: UIView) {
        for subView in view.subviews {
            subView.removeFromSuperview()
        }
    }
    
    private func controlMissionView(mission exist: Bool) {
        missionNotPostedLabel.isHidden = exist
        missionDescriptionLabel.isHidden = !exist
        missionTitleLabel.isHidden = !exist
        if !exist {
            missionImageView.image = nil
            clearSubViews(participantsScrollView)
        }
    }
    
    private func addViewDashBorder(at view: UIView) {
        let dashBorder = CAShapeLayer()
        dashBorder.strokeColor = UIColor(red: 221, green: 221, blue: 221).cgColor
        dashBorder.fillColor = nil
        dashBorder.lineDashPattern = [5, 3]
        dashBorder.frame = view.bounds
        dashBorder.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 30).cgPath
        dashBorder.lineWidth = 2
        view.layer.addSublayer(dashBorder)
    }
    
    private func removeViewDashBorder(at view: UIView) {
        guard let layers = view.layer.sublayers else {
            return
        }
        for index in 0..<layers.count {
            if layers[index] is CAShapeLayer {
                view.layer.sublayers?.remove(at: index)
            }
        }
    }
}

// MARK:- Mission Control

extension BeeMainViewController {
    
    /// Confirm Questionor
    
    private func isTodayQuestioner() -> Bool {
        guard let myNickname = UserDefaults.standard.string(forKey: UserDefaultsKey.myNickname.rawValue),
              let todayQuestioner = beeInfo?.todayQuestioner.nickname else {
            return false
        }
        return todayQuestioner == myNickname
    }
    
    private func isNextQuestioner() -> Bool {
        guard let myNickname = UserDefaults.standard.string(forKey: UserDefaultsKey.myNickname.rawValue),
              let nextQuestioner = beeInfo?.nextQuestioner.nickname else {
            return false
        }
        return nextQuestioner == myNickname
    }
    
    /// Mission Time Control
    
    private func isSubmitMissionTime() -> Bool {
        let dateString = dateFormatterForLabel.string(from: Date())
        guard let startTime = beeInfo?.startTime,
              let endTime = beeInfo?.endTime,
              let startTimeDate = dateFormatterForTime.date(from: "\(dateString) \(startTime)"),
              let endTimeDate = dateFormatterForTime.date(from: "\(dateString) \(endTime)") else {
            return false
        }
        if startTimeDate <= Date() && Date() <= endTimeDate {
            return true
        }
        return true
//        return false
    }
    
    private func isCreateMissionTime() -> Bool {
        let dateString = dateFormatterForLabel.string(from: Date())
        guard let endTime = beeInfo?.endTime,
              let endTimeDate = dateFormatterForTime.date(from: "\(dateString) \(endTime)") else {
            return false
        }
        if Date() <= endTimeDate {
            return true
        }
        return false
    }
    
    private func getPresentedTargetView() -> ViewPresentPeriod {
        guard let targetDate = UserDefaults.standard.object(forKey: UserDefaultsKey.targetDate.rawValue) as? Date,
              let today = dateFormatterForLabel.date(from: dateFormatterForLabel.string(from: Date())) else {
            return .today
        }
        if targetDate < today {
            return .past
        } else if targetDate == today {
            return .today
        } else {
            return .tomorrow
        }
    }
    
    /// Submit Control
    
    private func didSubmitMission() -> Bool {
        guard let missions = missions,
              let nickname = UserDefaults.standard.string(forKey: UserDefaultsKey.myNickname.rawValue) else {
            return false
        }
        for mission in missions {
            if mission.nickname == nickname {
                return true
            }
        }
        return false
    }
}

// MARK:- Navigation Control

extension BeeMainViewController: UIViewControllerTransitioningDelegate {
    
    @objc private func touchupCreateMissionButton(_ sender: UIButton) {
        navigationController?.pushViewController(MissionCreateViewController(), animated: true)
    }
    
    @objc private func touchupSubmitMissionButton(_ sender: UIButton) {
        let submitMissionViewController = SubmitMissionViewContoller()
        submitMissionViewController.modalPresentationStyle = .overCurrentContext
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 0.4
        } completion: { _ in
            self.present(submitMissionViewController, animated: true)
        }
    }
    
    @objc private func dismissSubView() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
        }
    }
    
    @objc private func touchupSettingButton(_ sender: UIButton) {
        navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    @objc private func touchupMissionListButton(_ sender: UIButton) {
        navigationController?.pushViewController(MissionListViewController(), animated: true)
    }
}

// MARK: Calendar

extension BeeMainViewController {
    
    @objc private func touchupCalendarButton(_ sender: UIButton) {
        let calendarViewController = CalendarViewController()
        calendarViewController.modalPresentationStyle = .popover
        let size = CGSize(width: 327 * DesignSet.frameWidthRatio, height: 360 * DesignSet.frameWidthRatio)
        calendarViewController.preferredContentSize = size
        calendarViewController.popoverPresentationController?.sourceView = view
        let x = view.bounds.midX
        let y = view.bounds.midY
        calendarViewController.popoverPresentationController?.sourceRect = CGRect(x: x, y: y, width: 0, height: 0)
        calendarViewController.popoverPresentationController?.permittedArrowDirections = .init()
        calendarViewController.popoverPresentationController?.delegate = self
        present(calendarViewController, animated: true, completion: nil)
    }
    
    private func setDateLabel() {
        let todayDate = dateFormatterForLabel.string(from: Date())
        dateLabel.text = todayDate
        guard let targetDate = dateFormatterForLabel.date(from: todayDate) else {
            return
        }
        UserDefaults.standard.set(targetDate, forKey: UserDefaultsKey.targetDate.rawValue)
        updateDateDescriptionLabel()
    }
    
    @objc private func changeDate() {
        guard let targetDate = UserDefaults.standard.object(forKey: UserDefaultsKey.targetDate.rawValue) as? Date else {
            return
        }
        dateLabel.text = dateFormatterForLabel.string(from: targetDate)
        updateDateDescriptionLabel()
        requestMain(changeDate: true)
    }
    
    private func updateDateDescriptionLabel() {
        switch getPresentedTargetView() {
        case .past:
            todaysMissionDescriptionLabel.text = "과거의 미션 사진"
            missionDescriptionLabel.text = "과거의 미션"
        case .today:
            todaysMissionDescriptionLabel.text = "오늘의 미션 사진"
            missionDescriptionLabel.text = "오늘의 미션"
        case .tomorrow:
            todaysMissionDescriptionLabel.text = "내일의 미션 사진"
            missionDescriptionLabel.text = "내일의 미션"
        }
    }
}

// MARK:- PopoverPresentaion Set

extension BeeMainViewController: UIPopoverPresentationControllerDelegate {
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK:- Main Request

extension BeeMainViewController {
    
    @objc private func requestMain(changeDate: Bool) {
        activityIndicator.startAnimating()
        let requestModel = MainModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let main = Request<Main>()
        if dateLabel.text == "" {
            setDateLabel()
        }
        let parameter = ["targetDate": dateLabel.text ?? "",
                         "beeId": "\(UserDefaults.standard.integer(forKey: UserDefaultsKey.beeId.rawValue))"]
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
            main.request(request: request, header: header, parameter: parameter) { (main, _, error) in
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                if let error = error {
                    presentConfirmAlert(title: "메인 요청 에러!", message: error.localizedDescription)
                    return
                }
                guard let main = main else {
                    presentConfirmAlert(title: "메인 요청 에러!", message: "")
                    return
                }
                beeInfo = main.beeInfo
                missions = main.missions
                DispatchQueue.main.async {
                    if !changeDate {
                        setupBeeInfo()
                    }
                    setupMissions()
                }
            }
        }
    }
}

// MARK:- Image Picker

extension BeeMainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc private func takePhotoFromLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    @objc private func takePhotoFromCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        UserDefaults.standard.set(selectedImage.jpegData(compressionQuality: 1.0),
                                  forKey: UserDefaultsKey.missionImage.rawValue)
        dismiss(animated: true) {
            let previewMissionViewController = PreviewMissionViewController()
            self.navigationController?.pushViewController(previewMissionViewController, animated: true)
        }
    }
}

// MARK:- Layout

extension BeeMainViewController {
    
    private func setLayout() {
        view.backgroundColor = UIColor(red: 255, green: 250, blue: 233)
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
        activityIndicator.addSubview(activityIndicatorImageView)
        activityIndicatorImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(activityIndicator.snp.width)
            $0.width.equalToSuperview()
        }
        activityIndicatorImageView.addSubview(activityIndicatorDescriptionLabel)
        activityIndicatorDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(26 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(mainBackgroundImageView)
        mainBackgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(430 * DesignSet.frameHeightRatio)
            $0.width.equalToSuperview()
        }
        view.addSubview(settingButton)
        settingButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28 * DesignSet.frameHeightRatio)
            $0.trailing.equalToSuperview().offset(-24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(18 * DesignSet.frameHeightRatio)
            $0.width.equalTo(18 * DesignSet.frameHeightRatio)
        }
        view.addSubview(beeTitleLabel)
        beeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(125 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(68 * DesignSet.frameHeightRatio)
            $0.width.equalTo(241 * DesignSet.frameWidthRatio)
        }
        view.addSubview(memberCountLabel)
        memberCountLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(205 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(292 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().offset(30 * DesignSet.frameHeightRatio)
            $0.width.equalToSuperview()
        }
        
        mainScrollView.addSubview(wonImageView)
        wonImageView.snp.makeConstraints {
            $0.top.equalTo(22 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(21 * DesignSet.frameHeightRatio)
            $0.width.equalTo(21 * DesignSet.frameHeightRatio)
        }
        mainScrollView.addSubview(jellyDescriptionLabel)
        jellyDescriptionLabel.snp.makeConstraints {
            $0.centerY.equalTo(wonImageView.snp.centerY)
            $0.leading.equalTo(wonImageView.snp.trailing).offset(6 * DesignSet.frameWidthRatio)
            $0.height.equalTo(17 * DesignSet.frameHeightRatio)
        }
        mainScrollView.addSubview(totalJelly)
        totalJelly.snp.makeConstraints {
            $0.centerY.equalTo(wonImageView.snp.centerY)
            $0.leading.equalTo(jellyDescriptionLabel.snp.trailing).offset(12 * DesignSet.frameWidthRatio)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        mainScrollView.addSubview(jellyReceiptButton)
        jellyReceiptButton.snp.makeConstraints {
            $0.centerY.equalTo(wonImageView.snp.centerY)
            $0.trailing.equalTo(view.snp.trailing).offset(-24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(27 * DesignSet.frameHeightRatio)
            $0.width.equalTo(72 * DesignSet.frameHeightRatio)
        }
        
        mainScrollView.addSubview(missionTimeDescriptionLabel)
        missionTimeDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(75 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(40 * DesignSet.frameWidthRatio)
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
        mainScrollView.addSubview(toBeDeterminedTimeView)
        toBeDeterminedTimeView.snp.makeConstraints {
            $0.top.equalTo(missionTimeDescriptionLabel.snp.bottom).offset(14 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(missionTimeDescriptionLabel.snp.centerX)
            $0.height.equalTo(54 * DesignSet.frameHeightRatio)
            $0.width.equalTo(54 * DesignSet.frameHeightRatio)
        }
        mainScrollView.addSubview(missionTimeAnimationView)
        missionTimeAnimationView.snp.makeConstraints {
            $0.top.equalTo(missionTimeDescriptionLabel.snp.bottom).offset(14 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(missionTimeDescriptionLabel.snp.centerX)
            $0.height.equalTo(54 * DesignSet.frameHeightRatio)
            $0.width.equalTo(54 * DesignSet.frameHeightRatio)
        }
        mainScrollView.addSubview(missionTimeLabel)
        missionTimeLabel.snp.makeConstraints {
            $0.top.equalTo(missionTimeDescriptionLabel.snp.bottom).offset(31 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(missionTimeDescriptionLabel.snp.centerX)
            $0.height.equalTo(21 * DesignSet.frameHeightRatio)
        }
        
        mainScrollView.addSubview(todayQuestionerDescriptionLabel)
        todayQuestionerDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(75 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
        mainScrollView.addSubview(todayQuestionerImageView)
        todayQuestionerImageView.snp.makeConstraints {
            $0.top.equalTo(todayQuestionerDescriptionLabel.snp.bottom).offset(17 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview().offset(-2 * DesignSet.frameWidthRatio)
            $0.height.equalTo(45 * DesignSet.frameHeightRatio)
            $0.width.equalTo(45 * DesignSet.frameHeightRatio)
        }
        mainScrollView.addSubview(todayQuestionerNicknameLabel)
        todayQuestionerNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(todayQuestionerDescriptionLabel.snp.bottom).offset(71 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(15 * DesignSet.frameHeightRatio)
        }
        mainScrollView.addSubview(nextQuestionerImageView)
        nextQuestionerImageView.snp.makeConstraints {
            $0.centerY.equalTo(todayQuestionerImageView.snp.centerY)
            $0.leading.equalTo(195 * DesignSet.frameWidthRatio)
            $0.height.equalTo(30 * DesignSet.frameHeightRatio)
            $0.width.equalTo(30 * DesignSet.frameHeightRatio)
        }
        
        mainScrollView.addSubview(difficultyDescriptionLabel)
        difficultyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(75 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(291.5 * DesignSet.frameWidthRatio)
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
        mainScrollView.addSubview(difficultyImageView)
        difficultyImageView.snp.makeConstraints {
            $0.top.equalTo(difficultyDescriptionLabel.snp.bottom).offset(12 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(difficultyDescriptionLabel.snp.centerX)
            $0.height.equalTo(60 * DesignSet.frameHeightRatio)
            $0.width.equalTo(60 * DesignSet.frameHeightRatio)
        }
        mainScrollView.addSubview(toBeDeterminedDifficultyView)
        toBeDeterminedDifficultyView.snp.makeConstraints {
            $0.top.equalTo(difficultyDescriptionLabel.snp.bottom).offset(14 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(difficultyDescriptionLabel.snp.centerX)
            $0.height.equalTo(54 * DesignSet.frameHeightRatio)
            $0.width.equalTo(54 * DesignSet.frameHeightRatio)
        }
        toBeDeterminedDifficultyView.addSubview(toBeDeterminedDifficultyLabel)
        toBeDeterminedDifficultyLabel.snp.makeConstraints {
            $0.centerX.equalTo(toBeDeterminedDifficultyView.snp.centerX)
            $0.centerY.equalTo(toBeDeterminedDifficultyView.snp.centerY)
        }
        
        mainScrollView.addSubview(todaysMissionDescriptionLabel)
        todaysMissionDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(201 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(32 * DesignSet.frameHeightRatio)
        }
        
        mainScrollView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(204 * DesignSet.frameHeightRatio)
            $0.trailing.equalTo(view.snp.trailing).offset(-54 * DesignSet.frameWidthRatio)
            $0.height.equalTo(21 * DesignSet.frameHeightRatio)
            $0.width.greaterThanOrEqualTo(76 * DesignSet.frameWidthRatio)
        }
        mainScrollView.addSubview(calendarButton)
        calendarButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.trailing.equalTo(view.snp.trailing).offset(-24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(18 * DesignSet.frameHeightRatio)
            $0.width.equalTo(18 * DesignSet.frameHeightRatio)
        }
        
        mainScrollView.addSubview(missionImageView)
        missionImageView.snp.makeConstraints {
            $0.top.equalTo(252 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(407 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        missionImageView.addSubview(missionBlurView)
        missionBlurView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
        mainScrollView.addSubview(shadowMissionView)
        shadowMissionView.snp.makeConstraints {
            $0.top.equalTo(639 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        
        missionImageView.addSubview(missionNotPostedLabel)
        missionNotPostedLabel.snp.makeConstraints {
            $0.centerX.equalTo(missionImageView.snp.centerX)
            $0.centerY.equalTo(missionImageView.snp.centerY)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        missionImageView.addSubview(missionDescriptionLabel)
        missionDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(289 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(29 * DesignSet.frameWidthRatio)
            $0.height.equalTo(17 * DesignSet.frameHeightRatio)
        }
        missionImageView.addSubview(missionTitleLabel)
        missionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(318 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(29 * DesignSet.frameWidthRatio)
            $0.height.equalTo(60 * DesignSet.frameHeightRatio)
            $0.width.equalTo(210 * DesignSet.frameWidthRatio)
        }
        mainScrollView.addSubview(createMissionButton)
        createMissionButton.snp.makeConstraints {
            $0.top.equalTo(544 * DesignSet.frameHeightRatio)
            $0.trailing.equalTo(missionImageView.snp.trailing).offset(-13 * DesignSet.frameWidthRatio)
            $0.height.equalTo(100 * DesignSet.frameHeightRatio)
            $0.width.equalTo(100 * DesignSet.frameHeightRatio)
        }
        
        mainScrollView.addSubview(participatedMissionDescriptionLabel)
        participatedMissionDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(695 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(24 * DesignSet.frameHeightRatio)
        }
        mainScrollView.addSubview(participantsScrollView)
        participantsScrollView.snp.makeConstraints {
            $0.top.equalTo(740 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(26 * DesignSet.frameWidthRatio)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(240 * DesignSet.frameHeightRatio)
        }
        participateButton.addSubview(participateImage)
        participateImage.snp.makeConstraints {
            $0.top.equalTo(58 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24 * DesignSet.frameHeightRatio)
            $0.width.equalTo(24 * DesignSet.frameHeightRatio)
        }
        participateButton.addSubview(participateLabel)
        participateLabel.snp.makeConstraints {
            $0.top.equalTo(106 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36 * DesignSet.frameHeightRatio)
        }
        
        shadowMissionView.layer.zPosition = 1
        missionImageView.layer.zPosition = 2
        createMissionButton.layer.zPosition = 3
        activityIndicator.layer.zPosition = 4
    }
}
