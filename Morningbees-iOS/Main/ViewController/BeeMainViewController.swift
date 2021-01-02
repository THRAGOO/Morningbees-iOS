//
//  BeeMainViewController.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2020/02/15.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Firebase
import UIKit
import GoogleSignIn
import NaverThirdPartyLogin

final class BeeMainViewController: UIViewController, CustomAlert {
    
// MARK:- Properties
    
    private let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private let mainBackgroundImg = DesignSet.initImageView(imgName: "mainBg")
    private let wonImg = DesignSet.initImageView(imgName: "oval")
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize.height = CGFloat(1300 * DesignSet.frameHeightRatio)
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSet.colorSet(red: 255, green: 250, blue: 233)
        return view
    }()
    
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "power"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(touchUpSignOutNaver), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchUpSignOutGoogle), for: .touchUpInside)
        return button
    }()
    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "iconNotificationDefault"), for: .normal)
        button.tintColor = .black
//        button.addTarget(self, action: #selector(), for: .touchUpInside)
        return button
    }()
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "iconSettings"), for: .normal)
        button.addTarget(self, action: #selector(touchupSettingButton), for: .touchUpInside)
        return button
    }()
    
    private let beeTitleLabel: UILabel = {
        let label = DesignSet.initLabel(text: "곰세마리가 한집에 있어 아빠곰 엄마곰 애기곰", letterSpacing: -0.6)
        label.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 26)
        label.numberOfLines = 2
        return label
    }()
    private let memberCountLabel: UILabel = {
        let label = DesignSet.initLabel(text: "전체멤버 3", letterSpacing: -0.58)
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.systemSemiBold.rawValue, size: 13)
        return label
    }()
    
    private let mainSubView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.backgroundColor = .white
        return view
    }()
    private let jellyCommentLabel: UILabel = {
        let label = DesignSet.initLabel(text: "총 누적 젤리", letterSpacing: -0.5)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 14)
        return label
    }()
    private let jelly: UILabel = {
        let label = DesignSet.initLabel(text: "120,000원", letterSpacing: -0.5)
        label.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 15)
        return label
    }()
    private let jellyDetailButton: UIButton = {
        let button = UIButton()
        button.setTitle("내역 확인", for: .normal)
        button.setTitleColor(DesignSet.colorSet(red: 68, green: 68, blue: 68), for: .normal)
        button.titleLabel?.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 12)
        button.layer.cornerRadius = 13.5
        button.layer.borderWidth = 1
        return button
    }()
    
    private let missionTimeCommentLabel: UILabel = {
        let label = DesignSet.initLabel(text: "미션 시간", letterSpacing: -0.62)
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 13)
        return label
    }()
    private let missionTimeView: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSet.colorSet(red: 246, green: 245, blue: 242)
        view.layer.cornerRadius = CGFloat(27 * DesignSet.frameWidthRatio)
        return view
    }()
    private let todaysBeeCommentLabel: UILabel = {
        let label = DesignSet.initLabel(text: "오늘의 꿀벌", letterSpacing: -0.62)
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 13)
        return label
    }()
    private let todaysBeeImgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = DesignSet.colorSet(red: 246, green: 245, blue: 242)
        view.layer.cornerRadius = CGFloat(22.5 * DesignSet.frameWidthRatio)
        return view
    }()
    private let tomorrowsBeeImgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = DesignSet.colorSet(red: 236, green: 235, blue: 232)
        view.layer.cornerRadius = CGFloat(15 * DesignSet.frameWidthRatio)
        return view
    }()
    private let difficultyCommentLabel: UILabel = {
        let label = DesignSet.initLabel(text: "난이도", letterSpacing: -0.62)
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 13)
        return label
    }()
    private let difficultyImgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = DesignSet.colorSet(red: 246, green: 245, blue: 242)
        view.layer.cornerRadius = CGFloat(27 * DesignSet.frameWidthRatio)
        return view
    }()
    
    private let todaysMissionCommentLabel: UILabel = {
        let label = DesignSet.initLabel(text: "오늘의 미션 사진", letterSpacing: -0.6)
        label.textColor = DesignSet.colorSet(red: 68, green: 68, blue: 68)
        label.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 20)
        return label
    }()
    
    static let dateLabel: UILabel = {
        let label = DesignSet.initLabel(text: "", letterSpacing: 0.0)
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.systemSemiBold.rawValue, size: 13)
        return label
    }()
    private let calendarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconCalendar"), for: .normal)
        button.tintColor = DesignSet.colorSet(red: 160, green: 160, blue: 160)
        button.addTarget(self, action: #selector(touchupCalendarButton), for: .touchUpInside)
        return button
    }()
    
    private let missionImgView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 30
        view.backgroundColor = DesignSet.colorSet(red: 248, green: 248, blue: 248)
        return view
    }()
    private let participateMissionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "participateInMission"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchupParticipateMissionButton), for: .touchUpInside)
        return button
    }()
    
    private let missionPictureCommentLabel: UILabel = {
        let label = DesignSet.initLabel(text: "미션 참여사진", letterSpacing: -0.6)
        label.textColor = DesignSet.colorSet(red: 68, green: 68, blue: 68)
        label.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 20)
        return label
    }()
    private let firstParticipateImgView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 18
        view.backgroundColor = DesignSet.colorSet(red: 248, green: 248, blue: 248)
        return view
    }()
    private let secondParticipateImgView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 18
        view.backgroundColor = DesignSet.colorSet(red: 248, green: 248, blue: 248)
        return view
    }()
    
// MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: Date())
        let month = calendar.component(.month, from: Date())
        let day = calendar.component(.day, from: Date())
        BeeMainViewController.dateLabel.text = "\(year)-0\(month)-0\(day)"
        mainRequest()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK:- Navigation Control

extension BeeMainViewController {
    
    @objc private func touchupParticipateMissionButton(_ sender: UIButton) {
        NavigationControl().pushToMissionCreateViewController()
    }
    
    @objc private func touchupSettingButton(_ sender: UIButton) {
        NavigationControl().pushToMemberViewController()
    }
    
    // MARK: Calendar
    
    @objc private func touchupCalendarButton(_ sender: UIButton) {
        guard let calendarViewController = self.storyboard?.instantiateViewController(
            withIdentifier: "CalendarViewController") else {
                return
        }
        calendarViewController.modalPresentationStyle = .popover
        calendarViewController.preferredContentSize = CGSize(width: 327 * DesignSet.frameWidthRatio,
                                                             height: 346 * DesignSet.frameHeightRatio)
        calendarViewController.popoverPresentationController?.sourceView = sender
        calendarViewController.popoverPresentationController?.sourceRect = sender.bounds
        calendarViewController.popoverPresentationController?.permittedArrowDirections = .right
        calendarViewController.popoverPresentationController?.delegate = self
        present(calendarViewController, animated: true, completion: nil)
    }
    
    static func updateDateLabel() {
        if let date = UserDefaults.standard.object(forKey: "missionDate") as? String {
            dateLabel.text = date
        }
    }
}

// MARK:- PopoverPresentaion Set

extension BeeMainViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK:- BeeInfomation Request

extension BeeMainViewController {
    
    private func mainRequest() {
        let reqModel = MainModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let beeInfo = Request<Main>()
        KeychainService.extractKeyChainToken { (accessToken, _, error) in
            if let error = error {
                self.presentOneButtonAlert(title: "Token Error", message: error.localizedDescription)
            }
            guard let accessToken = accessToken else {
                return
            }
            let param = ["targetDate": BeeMainViewController.dateLabel.text ?? "",
                         "beeId": "\(UserDefaults.standard.integer(forKey: "beeID"))"]
            
            let header: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            
            beeInfo.request(req: request, header: header, param: param) { (main, error) in
                if let error = error {
                    self.presentOneButtonAlert(title: "Main", message: error.localizedDescription)
                    return
                }
                guard let main = main else {
                    return
                }
                self.beeTitleLabel.text = main.beeInfos[0].title
                self.jelly.text = "\(main.beeInfos[0].totalPenalty)원"
            }
        }
    }
}

// MARK:- SignOut Naver

extension BeeMainViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    }

    func oauth20ConnectionDidFinishDeleteToken() {
        NavigationControl().popToRootViewController()
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        presentOneButtonAlert(title: "Error!", message: error.localizedDescription)
    }

    // MARK: Action

    @objc private func touchUpSignOutNaver(_ sender: UIButton) {
        naverSignInInstance?.delegate = self
        naverSignInInstance?.resetToken()
        NavigationControl().popToRootViewController()
    }
}

// MARK:- SignOut Google

extension BeeMainViewController {

    // MARK: Action

    @objc private func touchUpSignOutGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        NavigationControl().popToRootViewController()
    }
}

// MARK:- View Design

extension BeeMainViewController {
    
    private func setupDesign() {
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(mainView)
        
        mainView.addSubview(mainBackgroundImg)
        mainView.addSubview(logOutButton)
        mainView.addSubview(notificationButton)
        mainView.addSubview(settingButton)
        
        mainView.addSubview(beeTitleLabel)
        mainView.addSubview(memberCountLabel)
        mainView.addSubview(mainSubView)
        
        mainSubView.addSubview(wonImg)
        mainSubView.addSubview(jellyCommentLabel)
        mainSubView.addSubview(jelly)
        mainSubView.addSubview(jellyDetailButton)
        
        mainSubView.addSubview(missionTimeCommentLabel)
        mainSubView.addSubview(missionTimeView)
        mainSubView.addSubview(todaysBeeCommentLabel)
        mainSubView.addSubview(todaysBeeImgView)
        mainSubView.addSubview(tomorrowsBeeImgView)
        mainSubView.addSubview(difficultyCommentLabel)
        mainSubView.addSubview(difficultyImgView)
        
        mainSubView.addSubview(todaysMissionCommentLabel)
        
        mainSubView.addSubview(BeeMainViewController.dateLabel)
        mainSubView.addSubview(calendarButton)
        
        mainSubView.addSubview(missionImgView)
        mainSubView.addSubview(participateMissionButton)
        
        mainSubView.addSubview(missionPictureCommentLabel)
        mainSubView.addSubview(firstParticipateImgView)
        mainSubView.addSubview(secondParticipateImgView)
        
        mainScrollView.layer.zPosition = 0
        mainView.layer.zPosition = 1
        mainSubView.layer.zPosition = 2
        missionImgView.layer.zPosition = 3
        participateMissionButton.layer.zPosition = 4
        
        DesignSet.constraints(view: mainScrollView, top: 0, leading: 0, height: 677, width: 375)
        DesignSet.constraints(view: mainView, top: -40, leading: 0, height: 1300, width: 375)
        
        DesignSet.constraints(view: mainBackgroundImg, top: 20, leading: 0, height: 429, width: 375)
        DesignSet.squareConstraints(view: logOutButton, top: 48, leading: 20, height: 20, width: 20)
        DesignSet.squareConstraints(view: notificationButton, top: 48, leading: 288, height: 18, width: 18)
        DesignSet.squareConstraints(view: settingButton, top: 48, leading: 333, height: 18, width: 18)
        
        DesignSet.constraints(view: beeTitleLabel, top: 166, leading: 24, height: 68, width: 290)
        DesignSet.constraints(view: memberCountLabel, top: 245, leading: 24, height: 16, width: 70)
        DesignSet.constraints(view: mainSubView, top: 331, leading: 0, height: 1009, width: 375)
        
        DesignSet.squareConstraints(view: wonImg, top: 22, leading: 24, height: 21, width: 21)
        DesignSet.flexibleConstraints(view: jellyCommentLabel, top: 24, leading: 51, height: 17, width: 65)
        jelly.snp.makeConstraints {
            $0.top.equalTo(23 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(jellyCommentLabel.snp.trailing).offset(12 * DesignSet.frameWidthRatio)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        DesignSet.constraints(view: jellyDetailButton, top: 18, leading: 279, height: 27, width: 72)
        
        DesignSet.flexibleConstraints(view: missionTimeCommentLabel, top: 75, leading: 40, height: 16, width: 56)
        DesignSet.squareConstraints(view: missionTimeView, top: 105, leading: 41, height: 54, width: 54)
        DesignSet.flexibleConstraints(view: todaysBeeCommentLabel, top: 75, leading: 158, height: 16, width: 58)
        DesignSet.squareConstraints(view: todaysBeeImgView, top: 108, leading: 163, height: 45, width: 45)
        DesignSet.squareConstraints(view: tomorrowsBeeImgView, top: 117, leading: 195.1, height: 30, width: 30)
        DesignSet.flexibleConstraints(view: difficultyCommentLabel, top: 75, leading: 291, height: 16, width: 33)
        DesignSet.squareConstraints(view: difficultyImgView, top: 105, leading: 280, height: 54, width: 54)
        
        DesignSet.flexibleConstraints(view: todaysMissionCommentLabel, top: 205, leading: 24, height: 24, width: 122)
        
        BeeMainViewController.dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(calendarButton.snp.centerY)
            $0.trailing.equalTo(calendarButton.snp.leading).offset(-12 * DesignSet.frameWidthRatio)
            $0.height.equalTo(21 * DesignSet.frameHeightRatio)
        }
        DesignSet.squareConstraints(view: calendarButton, top: 209, leading: 333, height: 18, width: 18)
        
        DesignSet.constraints(view: missionImgView, top: 252, leading: 24, height: 407, width: 327)
        DesignSet.squareConstraints(view: participateMissionButton, top: 544, leading: 238, height: 100, width: 100)
        
        DesignSet.flexibleConstraints(view: missionPictureCommentLabel, top: 695, leading: 24, height: 24, width: 105)
        DesignSet.constraints(view: firstParticipateImgView, top: 739, leading: 26, height: 240, width: 180)
        DesignSet.constraints(view: secondParticipateImgView, top: 739, leading: 227, height: 240, width: 180)
    }
}
