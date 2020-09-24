//
//  InvitedViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/08/26.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class InvitedViewController: UIViewController {
    
//MARK:- Properties
    
    private let invitationImageViwe = DesignSet.initImageView(imgName: "illustInvite")
    
    private let mainDescriptLabel: UILabel = {
        let label = DesignSet.initLabel(text: "여왕벌에게 초대장이 도착하였습니다.", letterSpacing: -0.6)
        label.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 24)
        label.textColor = DesignSet.colorSet(red: 34, green: 34, blue: 34)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private let invitedLabel: UILabel = {
        let label = DesignSet.initLabel(text: "", letterSpacing: -0.26)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 14)
        label.textColor = DesignSet.colorSet(red: 68, green: 68, blue: 68)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
//MARK:- Life Cycle
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupDesign()
    }
}

//MARK:- View Design

extension InvitedViewController {
    
    private func setupDesign() {
        guard let beeTitle = UserDefaults.standard.object(forKey: "beeTitle") as? String else {
            return
        }
        invitedLabel.text = "\(beeTitle)에 참여하여 미션을 함께 클리어 해 볼까요?"
        
        view.addSubview(invitationImageViwe)
        
        view.addSubview(mainDescriptLabel)
        view.addSubview(invitedLabel)
        
        DesignSet.constraints(view: invitationImageViwe, top: 87, leading: 67, height: 240, width: 240)
        
        mainDescriptLabel.snp.makeConstraints {
            $0.top.equalTo(364 * DesignSet.frameHeightRatio)
            $0.height.equalTo(66 * DesignSet.frameHeightRatio)
            $0.width.equalTo(270 * DesignSet.frameWidthRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
        invitedLabel.snp.makeConstraints {
            $0.top.equalTo(451 * DesignSet.frameHeightRatio)
            $0.height.equalTo(40 * DesignSet.frameHeightRatio)
            $0.width.equalTo(208 * DesignSet.frameWidthRatio)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
}
