//
//  SettingViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/18.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class SettingViewController: UIViewController, CustomAlert {
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(toPreviousViewController), for: .touchUpInside)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel(text: "설정", letterSpacing: -0.3)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        label.font = UIFont(font: .systemSemiBold, size: 17)
        return label
    }()
    private let bottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 229, green: 229, blue: 229).cgColor
        return view
    }()
    
    private let settingTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 0
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let myInfoHeaderView: UITableViewHeaderFooterView = {
        let view = UITableViewHeaderFooterView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 241, green: 241, blue: 241).cgColor
        let backgroudView = UIView()
        backgroudView.backgroundColor = UIColor(red: 248, green: 248, blue: 248)
        view.backgroundView = backgroudView
        return view
    }()
    private let myInfoHeaderViewImageView = UIImageView(imageName: "settingBee")
    private let myInfoHeaderViewLabel: UILabel = {
        let label = UILabel(text: "내 정보", letterSpacing: -0.5)
        label.font = UIFont(font: .systemMedium, size: 13)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        return label
    }()
    
    private let beeInfoHeaderView: UITableViewHeaderFooterView = {
        let view = UITableViewHeaderFooterView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 241, green: 241, blue: 241).cgColor
        let backgroudView = UIView()
        backgroudView.backgroundColor = UIColor(red: 248, green: 248, blue: 248)
        view.backgroundView = backgroudView
        return view
    }()
    private let beeInfoHeaderViewImageView = UIImageView(imageName: "beeGroup")
    private let beeInfoHeaderViewLabel: UILabel = {
        let label = UILabel(text: "모임 관리", letterSpacing: -0.5)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemMedium, size: 13)
        return label
    }()
    
    private let leaveHeaderView: UITableViewHeaderFooterView = {
        let view = UITableViewHeaderFooterView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 241, green: 241, blue: 241).cgColor
        let backgroudView = UIView()
        backgroudView.backgroundColor = UIColor(red: 248, green: 248, blue: 248)
        view.backgroundView = backgroudView
        return view
    }()
    
    private var missionTimeString: String = ""
    private var totalPenaltyString: String = ""
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(SettingTableViewCell.self,
                                 forCellReuseIdentifier: SettingTableViewCell.identifier)
        requestBeeInfo()
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NavigationControl.navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK:- Navigation

extension SettingViewController {
    
    @objc private func toPreviousViewController() {
        NavigationControl.popViewController()
    }
    
    private func pushToRoyalJellyViewController() {
        NavigationControl.pushToRoyalJellyViewController()
    }
}

// MARK:- TableView

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier,
                                                       for: indexPath) as? SettingTableViewCell else {
            fatalError()
        }
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = UserDefaults.standard.string(forKey: UserDefaultsKey.myNickname.rawValue)
            cell.isUserInteractionEnabled = false
            cell.imageView?.isHidden = true
        case 1:
            switch indexPath.row {
            case 0:
                cell.configure(with: SettingContent(title: .missionTime, detail: missionTimeString, needArrow: false))
            case 1:
                cell.configure(with: SettingContent(title: .royalJelly, detail: totalPenaltyString, needArrow: true))
            case 2:
                cell.configure(with: SettingContent(title: .memberList, detail: "", needArrow: true))
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.configure(with: SettingContent(title: .logout, detail: "", needArrow: true))
            case 1:
                if !UserDefaults.standard.bool(forKey: UserDefaultsKey.isQueenBee.rawValue) {
                    cell.configure(with: SettingContent(title: .leaveBee, detail: "", needArrow: true))
                } else {
                    cell.configure(with: SettingContent(title: .none, detail: "", needArrow: false))
                }
            default:
                break
            }
        default:
            break
        }
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return myInfoHeaderView
        case 1:
            return beeInfoHeaderView
        case 2:
            return leaveHeaderView
        default:
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(36 * ToolSet.heightRatio)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(54 * ToolSet.heightRatio)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                break
            case 1:
                NavigationControl.pushToRoyalJellyViewController()
            case 2:
                NavigationControl.pushToMemberViewController()
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                presentYesNoAlert(title: "로그아웃", message: "정말로 로그아웃 하시겠습니까?") { [self] _ in
                    signOut()
                }
            case 1:
                if !UserDefaults.standard.bool(forKey: UserDefaultsKey.isQueenBee.rawValue) {
                    presentYesNoAlert(title: "모임 떠나기", message: "정말로 모임을 떠나시겠습니까?") { [self] _ in
                        leaveBee()
                    }
                }
            default:
                break
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- BeeInfo Request

extension SettingViewController {
    
    private func requestBeeInfo() {
        let requestModel = BeeInfoModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let beeInfo = Request<BeeInfo>()
        KeychainService.extractKeyChainToken { [self] (accessToken, _, error) in
            if let error = error {
                presentConfirmAlert(title: "토큰 에러!", message: error.description)
            }
            guard let accessToken = accessToken else {
                return
            }
            let header: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            beeInfo.request(request: request, header: header, parameter: "") { (beeInfo, _, error) in
                if let error = error {
                    presentConfirmAlert(title: "모임 정보 요청 에러!", message: error.description)
                    return
                }
                guard let beeInfo = beeInfo else {
                    return
                }
                DispatchQueue.main.async {
                    missionTimeString = "\(beeInfo.startTime[0])시 - \(beeInfo.endTime[0])시"
                    totalPenaltyString = ToolSet.integerToCommaNumberString(with: beeInfo.pay) + "원"
                    settingTableView.reloadData()
                }
            }
        }
    }
}

// MARK:- Sign Out

extension SettingViewController {
    
    private func signOut() {
        removeAllInfomations()
        NavigationControl.popToRootViewController()
    }
    
    private func removeAllInfomations() {
        KeychainService.deleteKeychainToken { [self] error in
            if let error = error {
                presentConfirmAlert(title: "토큰 에러!", message: error.description)
            }
        }
        UserDefaultsKey.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

// MARK:- Leave Bee

extension SettingViewController {
    
    private func leaveBee() {
        WithdrawalAPI().request { [self] (success, error) in
            if let error = error {
                presentConfirmAlert(title: "떠나기 요청 에러!", message: error.description)
            }
            if let success = success {
                if success {
                    presentConfirmAlert(title: "행운은 빕니다!", message: "당신은 이제 자유입니다!") { _ in
                        navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    presentConfirmAlert(title: "실패!", message: "")
                }
            }
        }
    }
}

// MARK: Layout

extension SettingViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(toPreviousButton)
        toPreviousButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11 * ToolSet.heightRatio)
            $0.leading.equalTo(12 * ToolSet.widthRatio)
            $0.height.equalTo(20 * ToolSet.heightRatio)
            $0.width.equalTo(30 * ToolSet.heightRatio)
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20 * ToolSet.heightRatio)
        }
        view.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(43 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        view.addSubview(settingTableView)
        settingTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(469 * ToolSet.heightRatio)
        }
        
        myInfoHeaderView.addSubview(myInfoHeaderViewImageView)
        myInfoHeaderViewImageView.snp.makeConstraints {
            $0.top.equalTo(myInfoHeaderView).offset(8 * ToolSet.heightRatio)
            $0.leading.equalTo(myInfoHeaderView).offset(25 * ToolSet.widthRatio)
            $0.height.equalTo(18 * ToolSet.heightRatio)
            $0.width.equalTo(16 * ToolSet.widthRatio)
        }
        myInfoHeaderView.addSubview(myInfoHeaderViewLabel)
        myInfoHeaderViewLabel.snp.makeConstraints {
            $0.centerY.equalTo(myInfoHeaderView)
            $0.leading.equalTo(myInfoHeaderView).offset(47 * ToolSet.widthRatio)
            $0.height.equalTo(16 * ToolSet.heightRatio)
        }
        
        beeInfoHeaderView.addSubview(beeInfoHeaderViewImageView)
        beeInfoHeaderViewImageView.snp.makeConstraints {
            $0.centerY.equalTo(beeInfoHeaderView)
            $0.leading.equalTo(beeInfoHeaderView).offset(25 * ToolSet.widthRatio)
            $0.height.equalTo(14 * ToolSet.heightRatio)
            $0.width.equalTo(16 * ToolSet.widthRatio)
        }
        beeInfoHeaderView.addSubview(beeInfoHeaderViewLabel)
        beeInfoHeaderViewLabel.snp.makeConstraints {
            $0.centerY.equalTo(beeInfoHeaderView)
            $0.leading.equalTo(beeInfoHeaderView).offset(48 * ToolSet.widthRatio)
            $0.height.equalTo(16 * ToolSet.heightRatio)
        }
    }
}
