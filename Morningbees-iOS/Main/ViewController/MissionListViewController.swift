//
//  MissionListViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/16.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class MissionListViewController: UIViewController {
    
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
        let label = UILabel(text: "참여 미션 요청 중...", letterSpacing: 0)
        label.textColor = .white
        label.font = UIFont(font: .systemBold, size: 24)
        return label
    }()
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(popToPrevViewController), for: .touchUpInside)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel(text: "미션 참여사진", letterSpacing: -0.3)
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
    
    private let missionTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var missions: [Missions]?
    
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
        missionTableView.delegate = self
        missionTableView.dataSource = self
        missionTableView.register(MissionTableViewCell.self, forCellReuseIdentifier: MissionTableViewCell.identifier)
        requestMissions()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK:- Navigation

extension MissionListViewController {
    
    @objc private func popToPrevViewController() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK:- TableView

extension MissionListViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MissionTableViewCell.identifier,
                                                       for: indexPath) as? MissionTableViewCell,
              let missions = missions else {
            fatalError()
        }
        cell.configure(with: missions[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(480 * DesignSet.frameHeightRatio)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- Missions Request

extension MissionListViewController: CustomAlert {
    
    private func requestMissions() {
        activityIndicator.startAnimating()
        let requestModel = MainModel()
        let request = RequestSet(method: requestModel.method, path: requestModel.path)
        let mission = Request<Main>()
        guard let targetDate = UserDefaults.standard.object(forKey: UserDefaultsKey.targetDate.rawValue) as? Date else {
            activityIndicator.stopAnimating()
            presentConfirmAlert(title: "미션 요청 에러!", message: "해당 날짜 값을 불러오지 못했습니다.")
            return
        }
        let targetDateString = dateFormatter.string(from: targetDate)
        let parameter = ["targetDate": targetDateString,
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
            mission.request(request: request, header: header, parameter: parameter) { (main, _, error) in
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                if let error = error {
                    presentConfirmAlert(title: "미션 요청 에러!", message: error.localizedDescription)
                    return
                }
                guard let missions = main?.missions else {
                    presentConfirmAlert(title: "미션 요청 에러!", message: "")
                    return
                }
                self.missions = missions
                DispatchQueue.main.async {
                    missionTableView.reloadData()
                }
            }
        }
    }
}

// MARK:- Layout

extension MissionListViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        
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
        
        view.addSubview(toPreviousButton)
        toPreviousButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(12 * DesignSet.frameHeightRatio)
            $0.width.equalTo(12 * DesignSet.frameWidthRatio)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(13 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
        }
        view.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        view.addSubview(missionTableView)
        missionTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(47 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        activityIndicator.layer.zPosition = 1
    }
}
