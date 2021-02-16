//
//  SettingViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/18.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit
import GoogleSignIn
import NaverThirdPartyLogin

final class SettingViewController: UIViewController, CustomAlert {
    
    private let naverSignInInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(toPrevViewController), for: .touchUpInside)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel(text: "설정", letterSpacing: -0.3)
        label.font = UIFont(font: .systemSemiBold, size: 17)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
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
        label.font = UIFont(font: .systemMedium, size: 13)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
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
        GIDSignIn.sharedInstance()?.presentingViewController = self
        naverSignInInstance?.delegate = self
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(SettingTableViewCell.self,
                                 forCellReuseIdentifier: SettingTableViewCell.identifier)
        beeInfoRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.backgroundColor = .white
        
        view.addSubview(toPreviousButton)
        toPreviousButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(view.snp.leading).offset(12 * DesignSet.frameWidthRatio)
            $0.width.equalTo(12 * DesignSet.frameWidthRatio)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
        }
        view.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(43 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(1 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(settingTableView)
        settingTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(469 * DesignSet.frameHeightRatio)
        }
        
        myInfoHeaderView.addSubview(myInfoHeaderViewImageView)
        myInfoHeaderViewImageView.snp.makeConstraints {
            $0.top.equalTo(myInfoHeaderView).offset(8 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(myInfoHeaderView).offset(25 * DesignSet.frameWidthRatio)
            $0.height.equalTo(18 * DesignSet.frameHeightRatio)
            $0.width.equalTo(16 * DesignSet.frameWidthRatio)
        }
        myInfoHeaderView.addSubview(myInfoHeaderViewLabel)
        myInfoHeaderViewLabel.snp.makeConstraints {
            $0.centerY.equalTo(myInfoHeaderView)
            $0.leading.equalTo(myInfoHeaderView).offset(47 * DesignSet.frameWidthRatio)
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
        
        beeInfoHeaderView.addSubview(beeInfoHeaderViewImageView)
        beeInfoHeaderViewImageView.snp.makeConstraints {
            $0.centerY.equalTo(beeInfoHeaderView)
            $0.leading.equalTo(beeInfoHeaderView).offset(25 * DesignSet.frameWidthRatio)
            $0.height.equalTo(14 * DesignSet.frameHeightRatio)
            $0.width.equalTo(16 * DesignSet.frameWidthRatio)
        }
        beeInfoHeaderView.addSubview(beeInfoHeaderViewLabel)
        beeInfoHeaderViewLabel.snp.makeConstraints {
            $0.centerY.equalTo(beeInfoHeaderView)
            $0.leading.equalTo(beeInfoHeaderView).offset(48 * DesignSet.frameWidthRatio)
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
    }
}

// MARK:- TableView

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier,
                                                       for: indexPath) as? SettingTableViewCell else {
            fatalError()
        }
        let isQueenBee = UserDefaults.standard.bool(forKey: UserDefaultsKey.isQueenBee.rawValue)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = UserDefaults.standard.string(forKey: UserDefaultsKey.myNickname.rawValue)
            cell.isUserInteractionEnabled = false
            cell.imageView?.isHidden = true
        case 1:
            switch indexPath.row {
            case 0:
                cell.configure(with: SettingContent(title: .missionTime,
                                                    detail: missionTimeString,
                                                    isQueenBee: isQueenBee,
                                                    isPushToOther: false))
            case 1:
                cell.configure(with: SettingContent(title: .royalJelly,
                                                    detail: totalPenaltyString,
                                                    isQueenBee: isQueenBee,
                                                    isPushToOther: true))
            case 2:
                cell.configure(with: SettingContent(title: .memberList,
                                                    detail: "",
                                                    isQueenBee: isQueenBee,
                                                    isPushToOther: true))
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.configure(with: SettingContent(title: .logout,
                                                    detail: "",
                                                    isQueenBee: isQueenBee,
                                                    isPushToOther: true))
            case 1:
                cell.configure(with: SettingContent(title: .leaveBee,
                                                    detail: "",
                                                    isQueenBee: isQueenBee,
                                                    isPushToOther: true))
            default:
                break
            }
        default:
            break
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(36 * DesignSet.frameHeightRatio)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(54 * DesignSet.frameHeightRatio)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                break
            case 1:
                navigationController?.pushViewController(RoyalJellyViewController(), animated: true)
            case 2:
                navigationController?.pushViewController(MemberViewController(), animated: true)
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                presentYesNoAlert(title: "로그아웃", message: "정말로 로그아웃 하시겠습니까?") { _ in
                    self.signOutNaver()
                    self.signOutGoogle()
                }
            case 1:
                presentYesNoAlert(title: "모임 떠나기", message: "정말로 모임을 떠나시겠습니까?") { _ in
                    self.leaveBee()
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
    
    private func beeInfoRequest() {
        let requestModel = BeeInfoModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let beeInfo = Request<BeeInfo>()
        KeychainService.extractKeyChainToken { (accessToken, _, error) in
            if let error = error {
                self.presentConfirmAlert(title: "토큰 에러!", message: error.localizedDescription)
            }
            guard let accessToken = accessToken else {
                return
            }
            
            let header: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            beeInfo.request(request: request, header: header, parameter: "") { (beeInfo, _, error) in
                if let error = error {
                    self.presentConfirmAlert(title: "모임 정보 요청 에러!", message: error.localizedDescription)
                    return
                }
                guard let beeInfo = beeInfo else {
                    return
                }
                self.missionTimeString = "\(beeInfo.startTime[0])시 - \(beeInfo.endTime[0])시"
                self.totalPenaltyString = "\(beeInfo.pay)원"
                DispatchQueue.main.async {
                    self.settingTableView.reloadData()
                }
            }
        }
    }
}

// MARK:- Navigation

extension SettingViewController {
    
    @objc private func toPrevViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func pushToRoyalJellyViewController() {
        navigationController?.pushViewController(RoyalJellyViewController(), animated: true)
    }
}

// MARK:- Sign Out

extension SettingViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error.localizedDescription)
    }
    
    private func signOutNaver() {
        removeAllInfomations()
        naverSignInInstance?.resetToken()
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func signOutGoogle() {
        removeAllInfomations()
        GIDSignIn.sharedInstance()?.signOut()
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func removeAllInfomations() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.alreadyJoin.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.beeId.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.beeTitle.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.isQueenBee.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.missionImage.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.myNickname.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.queenBee.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.targetDate.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userId.rawValue)
    }
}

// MARK:- Leave Bee

extension SettingViewController {
    
    private func leaveBee() {
        WithdrawalAPI().request { [self] (success, error) in
            if let error = error {
                presentConfirmAlert(title: "떠나기 요청 에러!", message: error.localizedDescription)
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
