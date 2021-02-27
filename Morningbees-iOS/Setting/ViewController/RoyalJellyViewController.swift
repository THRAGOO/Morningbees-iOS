//
//  RoyalJellyViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/21.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class RoyalJellyViewController: UIViewController {
    
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
        let label = UILabel(text: "로얄젤리 불러오는 중...", letterSpacing: 0)
        label.textColor = .white
        label.font = UIFont(font: .systemBold, size: 24)
        return label
    }()
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(toPreviousViewController), for: .touchUpInside)
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
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        return tableView
    }()
    private let pastJellyReceiptTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private let penaltyButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = UIColor(red: 242, green: 242, blue: 242)
        let partialPaymentButton = UIButton()
        partialPaymentButton.setTitle("부분 차감", for: .normal)
        partialPaymentButton.titleLabel?.font = UIFont(font: .systemBold, size: 15)
        partialPaymentButton.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .normal)
        partialPaymentButton.addTarget(self, action: #selector(touchupPartialPaymentButton), for: .touchUpInside)
        stackView.addArrangedSubview(partialPaymentButton)
        let fullPaymentButton = UIButton()
        fullPaymentButton.setTitle("전액 납부", for: .normal)
        fullPaymentButton.titleLabel?.font = UIFont(font: .systemBold, size: 15)
        fullPaymentButton.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .normal)
        fullPaymentButton.addTarget(self, action: #selector(requestUpdateJelly), for: .touchUpInside)
        stackView.addArrangedSubview(fullPaymentButton)
        stackView.isHidden = true
        return stackView
    }()
    private let multiPenaltyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 242, green: 242, blue: 242)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 15)
        button.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .normal)
        button.addTarget(self, action: #selector(requestUpdateJelly), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private var penalties = [Penalty]()
    private var histories = [Penalty]()
    private var selectedTableViewCell = [Penalty]()
    
    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        unPaidMemberListTableView.delegate = self
        unPaidMemberListTableView.dataSource = self
        unPaidMemberListTableView.register(RoyalJellyTableViewCell.self,
                                           forCellReuseIdentifier: RoyalJellyTableViewCell.identifier)
        pastJellyReceiptTableView.delegate = self
        pastJellyReceiptTableView.dataSource = self
        pastJellyReceiptTableView.register(RoyalJellyTableViewCell.self,
                                           forCellReuseIdentifier: RoyalJellyTableViewCell.identifier)
        requestBeePenalty(type: 0)
        requestBeePenalty(type: 1)
        setLayout()
        setupButtonStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissPopupView),
                                               name: Notification.Name.init("DismissSearchView"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissPopupView),
                                               name: Notification.Name.init("DismissUpdateJellyView"),
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NavigationControl.navigationController.interactivePopGestureRecognizer?.isEnabled = true
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
    
    @objc private func toPreviousViewController() {
        NavigationControl.popViewController()
    }
    
    private func popupUpdateJellyViewController(userId: Int, penalty: Int) {
        let updateJellyViewController = UpdateJellyViewController(userid: userId, maxJelly: penalty)
        updateJellyViewController.modalPresentationStyle = .overCurrentContext
        UIView.animate(withDuration: 0.2) { [self] in
            view.alpha = 0.4
        } completion: { [self] _ in
            present(updateJellyViewController, animated: true)
        }
    }
}

// MARK:- TableView

extension RoyalJellyViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case unPaidMemberListTableView:
            return penalties.count
        case pastJellyReceiptTableView:
            return histories.count
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoyalJellyTableViewCell.identifier,
                                                       for: indexPath) as? RoyalJellyTableViewCell else {
            fatalError()
        }
        switch tableView {
        case unPaidMemberListTableView:
            cell.configure(with: penalties[indexPath.row])
            return cell
        case pastJellyReceiptTableView:
            cell.configure(with: histories[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case unPaidMemberListTableView:
            guard let cell = tableView.cellForRow(at: indexPath) as? RoyalJellyTableViewCell else {
                return
            }
            if UserDefaults.standard.bool(forKey: UserDefaultsKey.isQueenBee.rawValue) {
                selectedTableViewCell.append(cell.penalty)
                controlPayButton()
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        case pastJellyReceiptTableView:
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RoyalJellyTableViewCell else {
            return
        }
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.isQueenBee.rawValue) {
            for index in 0 ..< selectedTableViewCell.count {
                if cell.penalty.userId == selectedTableViewCell[index].userId {
                    selectedTableViewCell.remove(at: index)
                    break
                }
            }
            controlPayButton()
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60 * DesignSet.frameHeightRatio)
    }
    
    private func deselectAllTabelViewRows() {
        guard let selectedRows = unPaidMemberListTableView.indexPathsForSelectedRows else {
            return
        }
        selectedRows.forEach { indexPath in
            unPaidMemberListTableView.deselectRow(at: indexPath, animated: false)
        }
        selectedTableViewCell.removeAll()
        controlPayButton()
    }
}

// MARK:- UI

extension RoyalJellyViewController {
    
    private func setupStackViewButton(title: PenaltyTableLabel) -> UIButton {
        let button = UIButton()
        button.setTitle(title.rawValue, for: .normal)
        button.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .normal)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 15)
        button.addTarget(self, action: #selector(didTapSegmentedButton), for: .touchUpInside)
        button.layer.zPosition = 1
        return button
    }
    
    private func setupButtonStackView() {
        buttonStackView.addArrangedSubview(setupStackViewButton(title: .unpaid))
        buttonStackView.addArrangedSubview(setupStackViewButton(title: .paid))
        selector.layer.zPosition = 0
        selector.frame.size = CGSize(width: 163.5 * DesignSet.frameWidthRatio,
                                     height: 48 * DesignSet.frameHeightRatio)
        buttonStackView.addSubview(selector)
        unPaidMemberListTableView.isHidden = false
        pastJellyReceiptTableView.isHidden = true
    }
    
    private func controlPayButton() {
        switch selectedTableViewCell.count {
        case 0:
            penaltyButtonStackView.isHidden = true
            multiPenaltyButton.isHidden = true
            updateUnPaidMemberListTableViewLayout(isButtonEnable: false)
        case 1:
            penaltyButtonStackView.isHidden = false
            multiPenaltyButton.isHidden = true
            updateUnPaidMemberListTableViewLayout(isButtonEnable: true)
        default:
            penaltyButtonStackView.isHidden = true
            multiPenaltyButton.setTitle("선택한 \(selectedTableViewCell.count)명, 전액 납부", for: .normal)
            multiPenaltyButton.isHidden = false
            updateUnPaidMemberListTableViewLayout(isButtonEnable: true)
        }
    }
    
    private func updateUnPaidMemberListTableViewLayout(isButtonEnable: Bool) {
        if isButtonEnable {
            unPaidMemberListTableView.snp.remakeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(295 * DesignSet.frameHeightRatio)
                $0.centerX.width.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60 * DesignSet.frameHeightRatio)
            }
        } else {
            unPaidMemberListTableView.snp.remakeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(295 * DesignSet.frameHeightRatio)
                $0.centerX.width.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
}

// MARK:- UX

extension RoyalJellyViewController {
    
    @objc private func didTapSegmentedButton(_ sender: UIButton) {
        guard let buttonTitle = sender.currentTitle else {
            return
        }
        if buttonTitle == PenaltyTableLabel.unpaid.rawValue {
            unpaidPenaltyLabel.isHidden = false
            unpaidPenaltyLabelUnderline.isHidden = false
            unPaidMemberListTableView.isHidden = false
            pastJellyReceiptTableView.isHidden = true
        } else {
            unpaidPenaltyLabel.isHidden = true
            unpaidPenaltyLabelUnderline.isHidden = true
            unPaidMemberListTableView.isHidden = true
            pastJellyReceiptTableView.isHidden = false
        }
        UIView.animate(withDuration: 0.3) { [self] in
            selector.frame.origin.x = sender.frame.origin.x
        }
    }
    
    @objc private func presentSearchView() {
        let searchViewController = SearchViewController()
        if pastJellyReceiptTableView.isHidden {
            searchViewController.royalJellyList = penalties
            searchViewController.isUnpaidList = true
        } else {
            searchViewController.royalJellyList = histories
            searchViewController.isUnpaidList = false
        }
        searchViewController.modalPresentationStyle = .overCurrentContext
        UIView.animate(withDuration: 0.2) { [self] in
            view.alpha = 0.4
        } completion: { [self] _ in
            present(searchViewController, animated: true)
        }
    }
    
    @objc private func touchupPartialPaymentButton() {
        guard let userId = selectedTableViewCell.first?.userId,
              let penalty = selectedTableViewCell.first?.penalty else {
            return
        }
        deselectAllTabelViewRows()
        popupUpdateJellyViewController(userId: userId, penalty: penalty)
    }
    
    @objc private func dismissPopupView(notification: NSNotification) {
        UIView.animate(withDuration: 0.2) { [self] in
            view.alpha = 1.0
        }
        // execute if update occurred in UpdateJellyViewController
        if let _ = notification.userInfo?["didUpdateJelly"] as? Bool {
            requestBeePenalty(type: 0)
            requestBeePenalty(type: 1)
        // execute if user selects value in search tableView
        } else if let userId = notification.userInfo?["userId"] as? Int,
                  let penalty = notification.userInfo?["penalty"] as? Int {
            popupUpdateJellyViewController(userId: userId, penalty: penalty)
        }
    }
}

// MARK:- BeePenalty Request

extension RoyalJellyViewController: CustomAlert {
    
    private func requestBeePenalty(type: Int) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        let requestModel = BeePenaltyModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let beePenalty = Request<BeePenalty>()
        KeychainService.extractKeyChainToken { [self] (accessToken, _, error) in
            if let error = error {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "토큰 에러!", message: error.localizedDescription)
            }
            guard let accessToken = accessToken else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "토큰 에러!", message: "")
                return
            }
            let header: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            let parameter: [String: Int] = ["status": type]
            beePenalty.request(request: request, header: header, parameter: parameter) { (beePenalty, _, error) in
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                if let error = error {
                    presentConfirmAlert(title: "모임 벌급 요청 에러!", message: error.localizedDescription)
                    return
                }
                guard let beePenalty = beePenalty else {
                    return
                }
                DispatchQueue.main.async {
                    switch type {
                    case 0:
                        penalties.removeAll()
                        for user in beePenalty.penalties {
                            if 0 < user.penalty {
                                penalties.append(user)
                            }
                        }
                        penalties.sort(by: {$0.penalty > $1.penalty})
                        unPaidMemberListTableView.reloadData()
                    case 1:
                        histories.removeAll()
                        histories = beePenalty.penalties
                        histories.sort(by: {$0.penalty > $1.penalty})
                        pastJellyReceiptTableView.reloadData()
                    default:
                        break
                    }
                    for receipt in beePenalty.penaltyHistories {
                        if receipt.status == 0 {
                            unpaidPenaltyLabel.text = "총 미납금 \(receipt.total)"
                        } else {
                            cumulativeJellyLabel.text = "\(receipt.total)"
                        }
                    }
                }
            }
        }
    }
}

// MARK:- Update Jelly Reqeust

extension RoyalJellyViewController {
    
    @objc private func requestUpdateJelly() {
        let requestModel = UpdateJellyModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let updateJelly = Request<UpdateJelly>()
        KeychainService.extractKeyChainToken { [self] (accessToken, _, error) in
            if let error = error {
                self.presentConfirmAlert(title: "토큰 에러!", message: error.localizedDescription)
            }
            guard let accessToken = accessToken else {
                return
            }
            let parameter = Penalties(penalties: selectedTableViewCell)
            let header: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            deselectAllTabelViewRows()
            updateJelly.request(request: request, header: header, parameter: parameter) { (_, success, error) in
                if success {
                    requestBeePenalty(type: 0)
                    requestBeePenalty(type: 1)
                } else {
                    if let error = error {
                        presentConfirmAlert(title: "로열 젤리 업데이트 요청 에러!", message: error.localizedDescription)
                        return
                    }
                    presentConfirmAlert(title: "로열 젤리 업데이트 요청 에러!", message: "요청이 성공적으로 수행되지 못했습니다.")
                }
            }
        }
    }
}

// MARK:- Layout

extension RoyalJellyViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.height.width.equalToSuperview()
        }
        activityIndicator.addSubview(activityIndicatorImageView)
        activityIndicatorImageView.snp.makeConstraints {
            $0.centerX.centerY.width.equalToSuperview()
            $0.height.equalTo(activityIndicator.snp.width)
        }
        activityIndicatorImageView.addSubview(activityIndicatorDescriptionLabel)
        activityIndicatorDescriptionLabel.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.height.equalTo(26 * DesignSet.frameHeightRatio)
        }
        
        view.addSubview(toPreviousButton)
        toPreviousButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(12 * DesignSet.frameWidthRatio)
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
            $0.centerX.equalToSuperview()
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
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        view.addSubview(pastJellyReceiptTableView)
        pastJellyReceiptTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(295 * DesignSet.frameHeightRatio)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(penaltyButtonStackView)
        penaltyButtonStackView.snp.makeConstraints {
            $0.height.equalTo(60 * DesignSet.frameHeightRatio)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        view.addSubview(multiPenaltyButton)
        multiPenaltyButton.snp.makeConstraints {
            $0.height.equalTo(60 * DesignSet.frameHeightRatio)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        unpaidPenaltyLabelUnderline.layer.zPosition = 0
        unpaidPenaltyLabel.layer.zPosition = 1
        activityIndicator.layer.zPosition = 2
    }
}
