//
//  RoyalJellyViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/21.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

class RoyalJellyViewController: UIViewController {
    
    // MARK:- Properties
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(toPrevViewController), for: .touchUpInside)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel(text: "로얄젤리", letterSpacing: -0.3)
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
    
    private let cumulativeDescriptionLabel: UILabel = {
        let label = UILabel(text: "총 누적 로얄젤리", letterSpacing: -0.3)
        label.font = UIFont(font: .systemSemiBold, size: 15)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        return label
    }()
    private let cumulativeJellyLabel: UILabel = {
        let label = UILabel(text: "0", letterSpacing: -0.5)
        label.font = UIFont(font: .systemBold, size: 40)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.layer.cornerRadius = CGFloat(24 * DesignSet.frameHeightRatio)
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor(red: 218, green: 218, blue: 218).cgColor
        stackView.layer.masksToBounds = true
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    let selector: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255, green: 218, blue: 34)
        view.layer.cornerRadius = CGFloat(24 * DesignSet.frameHeightRatio)
        view.layer.borderWidth = 3.5
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    private let userListDescriptionLabel: UILabel = {
        let label = UILabel(text: "꿀벌 목록", letterSpacing: -0.3)
        label.font = UIFont(font: .systemSemiBold, size: 15)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        return label
    }()
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(presentSearchView), for: .touchUpInside)
        return button
    }()
    private let unpaidPenaltyLabel: UILabel = {
        let label = UILabel(text: "총 미납금 0", letterSpacing: -0.3)
        label.font = UIFont(font: .systemSemiBold, size: 15)
        label.textColor = UIColor(red: 68, green: 68, blue: 68)
        return label
    }()
    private let unpaidPenaltyLabelUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255, green: 239, blue: 158)
        return view
    }()
    
    private let unPaidMemberListTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsMultipleSelection = true
        tableView.tableFooterView = UIView()
        return tableView
    }()
    private let pastJellyReceiptTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private let penaltyButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = UIColor(red: 242, green: 242, blue: 242)
        let updatePartialPenaltyButton = UIButton()
        updatePartialPenaltyButton.setTitle("부분 차감", for: .normal)
        updatePartialPenaltyButton.titleLabel?.font = UIFont(font: .systemBold, size: 15)
        updatePartialPenaltyButton.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .normal)
        updatePartialPenaltyButton.addTarget(self, action: #selector(presentUpdateJellyView), for: .touchUpInside)
        stackView.addArrangedSubview(updatePartialPenaltyButton)
        let updateEntirePenaltyButton = UIButton()
        updateEntirePenaltyButton.setTitle("전액 납부", for: .normal)
        updateEntirePenaltyButton.titleLabel?.font = UIFont(font: .systemBold, size: 15)
        updateEntirePenaltyButton.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .normal)
        stackView.addArrangedSubview(updateEntirePenaltyButton)
        stackView.isHidden = true
        return stackView
    }()
    private let multiPenaltyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 242, green: 242, blue: 242)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 15)
        button.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private var penalties = [Penalty]()
    private var histories = [Penalty]()
    private var selectedTableViewCellData = [Penalty]()
    
    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        unPaidMemberListTableView.delegate = self
        unPaidMemberListTableView.dataSource = self
        unPaidMemberListTableView.register(UnpaidMemberTableViewCell.self,
                                           forCellReuseIdentifier: UnpaidMemberTableViewCell.identifier)
        pastJellyReceiptTableView.delegate = self
        pastJellyReceiptTableView.dataSource = self
        pastJellyReceiptTableView.register(PastJellyReceiptTableViewCell.self,
                                           forCellReuseIdentifier: PastJellyReceiptTableViewCell.identifier)
        layout()
        setupButtonStackView()
        beePenaltyRequest(type: 0)
        beePenaltyRequest(type: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissSubView),
                                               name: Notification.Name.init("DismissSearchView"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissSubView),
                                               name: Notification.Name.init("DismissUpdateJellyView"),
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.init("DismissSearchView"),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.init("DismissUpdateJellyView"),
                                                  object: nil)
    }
}

// MARK:- Navigation

extension RoyalJellyViewController {
    
    @objc private func toPrevViewController() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK:- TableView

extension RoyalJellyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case unPaidMemberListTableView:
            return penalties.count
        case pastJellyReceiptTableView:
            return histories.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case unPaidMemberListTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UnpaidMemberTableViewCell.identifier,
                                                           for: indexPath) as? UnpaidMemberTableViewCell else {
                fatalError()
            }
            cell.configure(with: penalties[indexPath.row])
            return cell
        case pastJellyReceiptTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PastJellyReceiptTableViewCell.identifier,
                                                           for: indexPath) as? PastJellyReceiptTableViewCell else {
                fatalError()
            }
            cell.configure(with: histories[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UnpaidMemberTableViewCell else {
            return
        }
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.isQueenBee.rawValue) {
            selectedTableViewCellData.append(cell.penalty)
            buttonControl()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UnpaidMemberTableViewCell else {
            return
        }
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.isQueenBee.rawValue) {
            for index in 0 ..< selectedTableViewCellData.count {
                if cell.penalty.nickname == selectedTableViewCellData[index].nickname {
                    selectedTableViewCellData.remove(at: index)
                    break
                }
            }
            buttonControl()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60 * DesignSet.frameHeightRatio)
    }
}

// MARK:- UI

extension RoyalJellyViewController {
    
    private func setupStackViewButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .normal)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 15)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.layer.zPosition = 1
        return button
    }
    
    private func setupButtonStackView() {
        buttonStackView.addArrangedSubview(setupStackViewButton(title: "미납 로얄젤리"))
        buttonStackView.addArrangedSubview(setupStackViewButton(title: "총 로얄젤리"))
        selector.layer.zPosition = 0
        selector.frame.size = CGSize(width: 163.5 * DesignSet.frameWidthRatio,
                                     height: 48 * DesignSet.frameHeightRatio)
        buttonStackView.addSubview(selector)
        unPaidMemberListTableView.isHidden = false
        pastJellyReceiptTableView.isHidden = true
    }
    
    @objc private func didTapButton(_ sender: UIButton) {
        guard let buttonTitle = sender.currentTitle else {
            return
        }
        if buttonTitle == "미납 로얄젤리" {
            unPaidMemberListTableView.isHidden = false
            pastJellyReceiptTableView.isHidden = true
        } else {
            unPaidMemberListTableView.isHidden = true
            pastJellyReceiptTableView.isHidden = false
        }
        UIView.animate(withDuration: 0.3) {
            self.selector.frame.origin.x = sender.frame.origin.x
        }
    }
    
    private func buttonControl() {
        switch selectedTableViewCellData.count {
        case 0:
            penaltyButtonStackView.isHidden = true
            multiPenaltyButton.isHidden = true
            setUnPaidMemberListTableViewLayout(buttonEnable: false)
        case 1:
            penaltyButtonStackView.isHidden = false
            multiPenaltyButton.isHidden = true
            setUnPaidMemberListTableViewLayout(buttonEnable: true)
        default:
            penaltyButtonStackView.isHidden = true
            multiPenaltyButton.setTitle("선택한 \(selectedTableViewCellData.count)명, 전액 납부", for: .normal)
            multiPenaltyButton.isHidden = false
            setUnPaidMemberListTableViewLayout(buttonEnable: true)
        }
    }
    
    private func setUnPaidMemberListTableViewLayout(buttonEnable: Bool) {
        if buttonEnable {
            unPaidMemberListTableView.snp.remakeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(295 * DesignSet.frameHeightRatio)
                $0.centerX.equalTo(view.snp.centerX)
                $0.width.equalTo(view.snp.width)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60 * DesignSet.frameHeightRatio)
            }
        } else {
            unPaidMemberListTableView.snp.remakeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(295 * DesignSet.frameHeightRatio)
                $0.centerX.equalTo(view.snp.centerX)
                $0.width.equalTo(view.snp.width)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
}

// MARK:- UX

extension RoyalJellyViewController {
    
    @objc private func presentSearchView() {
        let searchViewController = SearchViewController(list: penalties)
        searchViewController.modalPresentationStyle = .overCurrentContext
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 0.4
        } completion: { _ in
            self.present(searchViewController, animated: true)
        }
    }
    
    @objc private func presentUpdateJellyView() {
        guard let nickname = selectedTableViewCellData.first?.nickname,
              let penalty = selectedTableViewCellData.first?.penalty else {
            return
        }
        let updateJellyViewController = UpdateJellyViewController(nickname: nickname, maxJelly: penalty)
        updateJellyViewController.modalPresentationStyle = .overCurrentContext
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 0.4
        } completion: { _ in
            self.present(updateJellyViewController, animated: true)
        }
    }
    
    @objc private func dismissSubView(notification: NSNotification) {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
        }
        guard let nickname = notification.userInfo?["nickname"] as? String,
              let penalty = notification.userInfo?["penalty"] as? Int else {
                return
        }
        let updateJellyViewController = UpdateJellyViewController(nickname: nickname, maxJelly: penalty)
        updateJellyViewController.modalPresentationStyle = .overCurrentContext
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 0.4
        } completion: { _ in
            self.present(updateJellyViewController, animated: true)
        }
    }
}

// MARK:- BeePenalty Request

extension RoyalJellyViewController: CustomAlert {
    
    private func beePenaltyRequest(type: Int) {
        let requestModel = BeePenaltyModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let beePenalty = Request<BeePenalty>()
        KeychainService.extractKeyChainToken { (accessToken, _, error) in
            if let error = error {
                self.presentConfirmAlert(title: "Token Error", message: error.localizedDescription)
            }
            guard let accessToken = accessToken else {
                return
            }
            
            let header: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            let parameter: [String: Int] = ["status": type]
            beePenalty.request(request: request, header: header, parameter: parameter) { (beePenalty, _, error) in
                if let error = error {
                    self.presentConfirmAlert(title: "BeePenalty", message: error.localizedDescription)
                    return
                }
                guard let beePenalty = beePenalty else {
                    return
                }
                DispatchQueue.main.async {
                    switch type {
                    case 0:
                        for penalty in beePenalty.penalties {
//                            if 0 < penalty.penalty {
                                self.penalties.append(penalty)
//                            }
                        }
                        self.penalties.sort(by: {$0.penalty > $1.penalty})
                        self.unPaidMemberListTableView.reloadData()
                    case 1:
                        self.histories = beePenalty.penalties
                        self.histories.sort(by: {$0.penalty > $1.penalty})
                        self.pastJellyReceiptTableView.reloadData()
                    default:
                        break
                    }
                    for list in beePenalty.penaltyHistories {
                        if list.status == 0 {
                            self.unpaidPenaltyLabel.text = "\(list.total)"
                        } else {
                            self.cumulativeJellyLabel.text = "\(list.total)"
                        }
                    }
                }
            }
        }
    }
}

// MARK:- Layout

extension RoyalJellyViewController {
    
    private func layout() {
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
        
        view.addSubview(cumulativeDescriptionLabel)
        cumulativeDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(83 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        view.addSubview(cumulativeJellyLabel)
        cumulativeJellyLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(108 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(48 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(189 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
            $0.height.equalTo(48 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(userListDescriptionLabel)
        userListDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(267 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(26 * DesignSet.frameWidthRatio)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(userListDescriptionLabel.snp.centerY)
            $0.leading.equalTo(userListDescriptionLabel.snp.trailing).offset(12 * DesignSet.frameWidthRatio)
            $0.width.equalTo(18 * DesignSet.frameHeightRatio)
            $0.height.equalTo(18 * DesignSet.frameHeightRatio)
        }
        view.addSubview(unpaidPenaltyLabel)
        unpaidPenaltyLabel.snp.makeConstraints {
            $0.top.equalTo(userListDescriptionLabel.snp.top)
            $0.trailing.equalToSuperview().offset(-24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        view.addSubview(unpaidPenaltyLabelUnderline)
        unpaidPenaltyLabelUnderline.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(278.5 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(unpaidPenaltyLabel)
            $0.height.equalTo(7 * DesignSet.frameHeightRatio)
            $0.width.equalTo(unpaidPenaltyLabel)
        }
        
        view.addSubview(unPaidMemberListTableView)
        unPaidMemberListTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(295 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(view.snp.width)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        view.addSubview(pastJellyReceiptTableView)
        pastJellyReceiptTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(295 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(view.snp.width)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(penaltyButtonStackView)
        penaltyButtonStackView.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(60 * DesignSet.frameHeightRatio)
            $0.width.equalTo(view.snp.width)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        view.addSubview(multiPenaltyButton)
        multiPenaltyButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(60 * DesignSet.frameHeightRatio)
            $0.width.equalTo(view.snp.width)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        unpaidPenaltyLabelUnderline.layer.zPosition = 0
        unpaidPenaltyLabel.layer.zPosition = 1
    }
}