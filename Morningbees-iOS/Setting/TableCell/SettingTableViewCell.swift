//
//  SettingTableViewCell.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/19.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class SettingTableViewCell: UITableViewCell {
    
    static let identifier = "SettingTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        textLabel?.textColor = UIColor(red: 68, green: 68, blue: 68)
        textLabel?.font = UIFont(font: .systemSemiBold, size: 15)
    
        detailTextLabel?.font = UIFont(font: .systemMedium, size: 13)
        detailTextLabel?.textColor = UIColor(red: 119, green: 119, blue: 119)
        
        imageView?.image = UIImage(named: "arrowRight")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        textLabel?.snp.makeConstraints {
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        detailTextLabel?.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        imageView?.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).offset(-23 * DesignSet.frameWidthRatio)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(10 * DesignSet.frameHeightRatio)
        }
    }
    
    func configure(with model: SettingContent) {
        textLabel?.text = model.title.rawValue
        detailTextLabel?.text = model.detail
        if model.needArrow {
            imageView?.isHidden = false
            detailTextLabel?.snp.makeConstraints {
                $0.trailing.equalTo(contentView.snp.trailing).offset(-41 * DesignSet.frameWidthRatio)
            }
        } else {
            imageView?.isHidden = true
            detailTextLabel?.snp.makeConstraints {
                $0.trailing.equalTo(contentView.snp.trailing).offset(-23 * DesignSet.frameWidthRatio)
            }
        }
    }
}
