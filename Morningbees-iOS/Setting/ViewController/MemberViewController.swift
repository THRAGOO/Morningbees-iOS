//
//  MemberViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/08/26.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

final class MemberViewController: UIViewController {
    
// MARK:- Properties
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(popToPreviousViewController), for: .touchUpInside)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel(text: "전체 꿀벌", letterSpacing: -0.3)
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
    
    private let searchView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
        view.setRatioCornerRadius(3)
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()
    private let searchImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "search"))
        imageView.alpha = 0.3
        return imageView
    }()
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임 검색"
        textField.addTarget(self, action: #selector(searchUser), for: .editingChanged)
        return textField
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel(text: "꿀벌 목록", letterSpacing: -0.3)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        label.font = UIFont(font: .systemSemiBold, size: 14)
        return label
    }()
    private let inviteLinkButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ 초대 링크 복사", for: .normal)
        button.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .normal)
        button.titleLabel?.font = UIFont(font: .systemSemiBold, size: 11)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red: 211, green: 211, blue: 211).cgColor
        button.setRatioCornerRadius(4)
        button.addTarget(self, action: #selector(touchupInviteButton), for: .touchUpInside)
        return button
    }()
    
    private let memberTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor(red: 241, green: 241, blue: 241).cgColor
        tableView.tableFooterView = UITableViewHeaderFooterView()
        return tableView
    }()
    
    private var bee = Members(members: nil)
    private var sortedProfiles = [Profile]()
    private var resultProfiles = [Profile]()
    
// MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        memberTableView.delegate = self
        memberTableView.dataSource = self
        memberTableView.register(MemberTableViewCell.self,
                                 forCellReuseIdentifier: MemberTableViewCell.identifier)
        requestMemberList()
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NavigationControl.navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK:- Navigation

extension MemberViewController {
    
    @objc private func popToPreviousViewController(_ sender: UIButton) {
        NavigationControl.popViewController()
    }
}

// MARK:- UX

extension MemberViewController: CustomAlert, UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.endEditing(true)
    }
}

// MARK:- Build DynamicLink

extension MemberViewController {
    
    @objc private func touchupInviteButton(_ sender: UIButton) {
        var components = URLComponents()
        components.scheme = Path.scheme.rawValue
        components.host = Path.linkHost.rawValue
        guard let beeTitle = UserDefaults.standard.string(forKey: UserDefaultsKey.beeTitle.rawValue) else {
            return
        }
        let beeId = UserDefaults.standard.integer(forKey: UserDefaultsKey.beeId.rawValue)
        let param = Invite(beeId: beeId, title: beeTitle)
        let queryItem = [URLQueryItem(name: "beeTitle", value: "\(param.title)"),
                         URLQueryItem(name: "beeId", value: "\(param.beeId)")]
        components.queryItems = queryItem
        guard let link = components.url,
              let shareLink = DynamicLinkComponents(link: link, domainURIPrefix: DynamicLinkItem.uriPrefix.rawValue),
              let myBundleID = Bundle.main.bundleIdentifier else {
            return
        }
        shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleID)
        shareLink.iOSParameters?.appStoreID = DynamicLinkItem.appStoreId.rawValue
        shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: DynamicLinkItem.androidPackage.rawValue)
        shareLink.shorten { [self] (url, _, error) in
            if let error = error {
                presentConfirmAlert(title: "링크 생성 에러!", message: error.localizedDescription)
            }
            guard let url = url else {
                return
            }
            let shareController: UIActivityViewController = {
              let activities: [Any] = ["모닝비즈로 부터 초대장이 왔습니다! 링크를 통해 확인해 주세요:)", url]
              let controller = UIActivityViewController(activityItems: activities,
                                                        applicationActivities: nil)
              return controller
            }()
            shareController.popoverPresentationController?.sourceView = sender as UIView
            present(shareController, animated: true, completion: nil)
        }
    }
}

// MARK:- TableView

extension MemberViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTextField.text?.count != 0 {
            return resultProfiles.count
        }
        return bee.members?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identifier,
                                                       for: indexPath) as? MemberTableViewCell else {
            fatalError()
        }
        if searchTextField.text?.count != 0 {
            cell.configure(with: resultProfiles[indexPath.row])
            return cell
        } else {
            cell.configure(with: sortedProfiles[indexPath.row])
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60 * DesignSet.frameHeightRatio)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchTextField.endEditing(true)
    }
}

// MARK:- TableView Scroll Event

extension MemberViewController: UIScrollViewDelegate {
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y.isLessThanOrEqualTo(CGFloat(-10.0 * DesignSet.frameHeightRatio)) {
            UIView.animate(withDuration: 0.1) { [self] in
                searchView.isHidden = false
                let y = CGFloat(58 * DesignSet.frameHeightRatio)
                subTitleLabel.transform = CGAffineTransform(translationX: 0, y: y)
                inviteLinkButton.transform = CGAffineTransform(translationX: 0, y: y)
                scrollView.transform = CGAffineTransform(translationX: 0, y: y)
            }
        } else if 10 < scrollView.contentOffset.y {
            searchView.isHidden = true
            subTitleLabel.transform = .identity
            inviteLinkButton.transform = .identity
            scrollView.transform = .identity
        }
    }
}

// MARK:- Members Request

extension MemberViewController {
    
    private func requestMemberList() {
        let requestModel = MembersModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let beeMembers = Request<Members>()
        KeychainService.extractKeyChainToken { [self] (accessToken, _, error) in
            if let error = error {
                presentConfirmAlert(title: "토큰 에러!", message: error.localizedDescription)
            }
            guard let accessToken = accessToken else {
                presentConfirmAlert(title: "토큰 에러!", message: "")
                return
            }
            let header: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            beeMembers.request(request: request, header: header, parameter: "") { (beeMembers, _, error) in
                if let error = error {
                    presentConfirmAlert(title: "Members", message: error.localizedDescription)
                    return
                }
                guard let beeMembers = beeMembers else {
                    return
                }
                bee = beeMembers
                sortUserList()
                DispatchQueue.main.async {
                    memberTableView.reloadData()
                }
            }
        }
    }
    
    private func sortUserList() {
        guard var profiles = bee.members,
              let queenBee = UserDefaults.standard.string(forKey: UserDefaultsKey.queenBee.rawValue) else {
            return
        }
        for index in 0 ..< profiles.count {
            if profiles[index].nickname == queenBee {
                sortedProfiles.append(profiles[index])
                profiles.remove(at: index)
                break
            }
        }
        for profile in profiles {
            sortedProfiles.append(profile)
        }
    }
}

// MARK:- Search Algorithm

extension MemberViewController {
    
    @objc private func searchUser() {
        resultProfiles.removeAll()
        guard let members = bee.members,
              let searchUser = searchTextField.text else {
            return
        }
        for member in members {
            if member.nickname.contains(searchUser) {
                resultProfiles.append(member)
            }
        }
        memberTableView.reloadData()
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        return true
    }
}

// MARK:- Layout

extension MemberViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(toPreviousButton)
        toPreviousButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11 * DesignSet.frameHeightRatio)
            $0.leading.equalToSuperview().offset(12 * DesignSet.frameWidthRatio)
            $0.width.equalTo(12 * DesignSet.frameWidthRatio)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
        }
        view.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(43 * DesignSet.frameHeightRatio)
            $0.centerX.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        view.addSubview(searchView)
        searchView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(64 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        searchView.addSubview(searchImageView)
        searchImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(10 * DesignSet.frameWidthRatio)
            $0.height.width.equalTo(18 * DesignSet.frameHeightRatio)
        }
        searchView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.leading.equalTo(searchImageView.snp.trailing).offset(6 * DesignSet.frameWidthRatio)
            $0.height.equalTo(18 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(59 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(17 * DesignSet.frameHeightRatio)
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.isQueenBee.rawValue) {
            view.addSubview(inviteLinkButton)
            inviteLinkButton.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52 * DesignSet.frameHeightRatio)
                $0.trailing.equalTo(-24 * DesignSet.frameWidthRatio)
                $0.height.equalTo(30 * DesignSet.frameHeightRatio)
                $0.width.equalTo(99 * DesignSet.frameWidthRatio)
            }
        }
        view.addSubview(memberTableView)
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(91 * DesignSet.frameHeightRatio)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
