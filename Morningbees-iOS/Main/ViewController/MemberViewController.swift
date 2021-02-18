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
        button.addTarget(self, action: #selector(popToPrevious), for: .touchUpInside)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = DesignSet.initLabel(text: "전체 꿀벌", letterSpacing: -0.3)
        label.textColor = DesignSet.colorSet(red: 34, green: 34, blue: 34)
        label.font = DesignSet.fontSet(name: TextFonts.systemSemiBold.rawValue, size: 17)
        return label
    }()
    private let bottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = DesignSet.colorSet(red: 229, green: 229, blue: 229).cgColor
        return view
    }()
    
    private let subTitleLabel: UILabel = {
        let label = DesignSet.initLabel(text: "꿀벌 목록", letterSpacing: -0.3)
        label.textColor = DesignSet.colorSet(red: 34, green: 34, blue: 34)
        label.font = DesignSet.fontSet(name: TextFonts.systemSemiBold.rawValue, size: 14)
        return label
    }()
    let inviteLinkButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ 초대 링크 복사", for: .normal)
        button.setTitleColor(DesignSet.colorSet(red: 68, green: 68, blue: 68), for: .normal)
        button.titleLabel?.font = DesignSet.fontSet(name: TextFonts.systemSemiBold.rawValue, size: 13)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = DesignSet.colorSet(red: 211, green: 211, blue: 211).cgColor
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(touchupInviteButton), for: .touchUpInside)
        return button
    }()
    
    let memberTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = CGFloat(60 * DesignSet.frameHeightRatio)
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = DesignSet.colorSet(red: 241, green: 241, blue: 241).cgColor
        return tableView
    }()
    
// MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupDesign()
    }
}

// MARK:- Navigation

extension MemberViewController {
    
    @objc private func popToPrevious(_ sender: UIButton) {
        NavigationControl().popToPrevViewController()
    }
}

// MARK:- Build DynamicLink

extension MemberViewController {
    
    @objc private func touchupInviteButton(_ sender: UIButton) {
        var components = URLComponents()
        components.scheme = Path.scheme.rawValue
        components.host = Path.linkHost.rawValue
        
        let param = Invite(beeID: UserDefaults.standard.integer(forKey: "beeID"), title: "아침사냥꾼")
        
        let queryItem = [URLQueryItem(name: "beeTitle", value: "\(param.title)"),
                         URLQueryItem(name: "beeID", value: "\(param.beeID)")]
        components.queryItems = queryItem
        
        guard let linkParameter = components.url else {
            return
        }
        guard let shareLink = DynamicLinkComponents(link: linkParameter,
                                                    domainURIPrefix: "https://thragoo.page.link") else {
            return
        }
        if let myBundleID = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleID)
        }
        shareLink.iOSParameters?.appStoreID = "454943023"
        shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.jasen.kimjaeseung.morningbees")
        
        shareLink.shorten { (url, warnings, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let warnings = warnings {
                for warning in warnings {
                    print(warning)
                }
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
            self.present(shareController, animated: true, completion: nil)
        }
    }
}

// MARK:- Custom Table View

extension MemberViewController: UITableViewDelegate {
    
}

// MARK:- Design Set

extension MemberViewController {
    
    private func setupDesign() {
        view.addSubview(toPreviousButton)
        view.addSubview(titleLabel)
        view.addSubview(bottomlineView)
        
        view.addSubview(subTitleLabel)
        view.addSubview(inviteLinkButton)
        
        view.addSubview(memberTableView)
        
        DesignSet.constraints(view: toPreviousButton, top: 42, leading: 24, height: 20, width: 12)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(42 * DesignSet.frameHeightRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
        DesignSet.constraints(view: bottomlineView, top: 67, leading: 0, height: 1, width: 375)
        
        DesignSet.flexibleConstraints(view: subTitleLabel, top: 82, leading: 24, height: 17, width: 50)
        DesignSet.constraints(view: inviteLinkButton, top: 75, leading: 252, height: 30, width: 99)
        
        DesignSet.constraints(view: memberTableView, top: 112, leading: 0, height: 555, width: 375)
    }
}
