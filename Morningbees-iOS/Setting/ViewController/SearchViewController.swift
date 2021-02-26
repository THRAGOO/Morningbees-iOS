//
//  SearchViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/24.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK:- Properties
    
    private let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setRatioCornerRadius(30)
        view.layer.masksToBounds = true
        return view
    }()
    
    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor(red: 34, green: 34, blue: 34)
        textField.font = UIFont(font: .systemMedium, size: 16)
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(searchUser), for: .editingChanged)
        return textField
    }()
    
    private let bottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 68, green: 68, blue: 69).cgColor
        return view
    }()
    
    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UITableViewHeaderFooterView()
        return tableView
    }()
    
    public var royalJellyList = [Penalty]()
    private var resultUserList = [Penalty]()
    public var isUnpaidList = false
    
    private var viewTranslation = CGPoint(x: 0, y: 0)
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(RoyalJellyTableViewCell.self,
                                 forCellReuseIdentifier: RoyalJellyTableViewCell.identifier)
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dismissViewByPan)))
        searchTextField.becomeFirstResponder()
    }
}

// MARK:- UX

extension SearchViewController {
    
    @objc private func dismissViewByPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
        case .ended:
            if viewTranslation.y < 100 {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [self] in
                    view.transform = .identity
                }
            } else {
                NotificationCenter.default.post(name: Notification.Name.init("DismissSearchView"), object: nil)
                dismiss(animated: true)
            }
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.endEditing(true)
    }
}

// MARK:- TableView

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultUserList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoyalJellyTableViewCell.identifier,
                                                       for: indexPath) as? RoyalJellyTableViewCell else {
            fatalError()
        }
        cell.configure(with: resultUserList[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? RoyalJellyTableViewCell else {
            return
        }
        if isUnpaidList && UserDefaults.standard.bool(forKey: UserDefaultsKey.isQueenBee.rawValue) {
            let userInfo = ["userId": selectedCell.penalty.userId,
                            "penalty": selectedCell.penalty.penalty] as [String: Any]
            NotificationCenter.default.post(name: Notification.Name.init("DismissSearchView"),
                                            object: nil,
                                            userInfo: userInfo)
            dismiss(animated: true)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60 * DesignSet.frameHeightRatio)
    }
}

// MARK:- Seach Algorithm

extension SearchViewController: UITextFieldDelegate {
    
    @objc private func searchUser() {
        resultUserList.removeAll()
        guard let searchUser = searchTextField.text else {
            return
        }
        for user in royalJellyList {
            if user.nickname.contains(searchUser) {
                resultUserList.append(user)
            }
        }
        searchTableView.reloadData()
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        return true
    }
}

// MARK:- Layout

extension SearchViewController {
    
    private func setLayout() {
        view.backgroundColor = .clear
        
        view.addSubview(searchView)
        searchView.snp.makeConstraints {
            $0.top.equalTo(74 * DesignSet.frameHeightRatio)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview().offset(100)
        }
        
        searchView.addSubview(searchIconImageView)
        searchIconImageView.snp.makeConstraints {
            $0.top.equalTo(24 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.width.equalTo(18 * DesignSet.frameWidthRatio)
            $0.height.equalTo(18 * DesignSet.frameHeightRatio)
        }
        searchView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(20 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(59 * DesignSet.frameWidthRatio)
            $0.width.equalTo(285 * DesignSet.frameWidthRatio)
            $0.height.equalTo(29 * DesignSet.frameHeightRatio)
        }
        searchView.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(54 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(searchView.snp.centerX)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
            $0.height.equalTo(1 * DesignSet.frameHeightRatio)
        }
        
        searchView.addSubview(searchTableView)
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(55 * DesignSet.frameHeightRatio)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.width.equalToSuperview()
        }
    }
}
