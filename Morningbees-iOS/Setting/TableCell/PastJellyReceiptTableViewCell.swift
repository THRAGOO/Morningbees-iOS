//
//  PastJellyReceiptTableViewCell.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/31.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class PastJellyReceiptTableViewCell: UITableViewCell {

    static let identifier = "PastJellyReceiptTableViewCell"
    public var history = Penalty(nickname: "", userId: 0, penalty: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        layer.borderWidth = 0
        
        textLabel?.font = UIFont(font: .systemMedium, size: 15)
        textLabel?.textColor = UIColor(red: 119, green: 119, blue: 119)
    
        detailTextLabel?.font = UIFont(font: .systemMedium, size: 13)
        detailTextLabel?.textColor = UIColor(red: 119, green: 119, blue: 119)
        detailTextLabel?.numberOfLines = 2
        
        imageView?.backgroundColor = UIColor(red: 226, green: 226, blue: 226)
        imageView?.layer.cornerRadius = CGFloat(18 * DesignSet.frameHeightRatio)
        imageView?.layer.masksToBounds = true
        imageView?.alpha = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView?.snp.makeConstraints {
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.equalTo(36 * DesignSet.frameHeightRatio)
            $0.height.equalTo(36 * DesignSet.frameHeightRatio)
        }
        
        textLabel?.snp.makeConstraints {
            if let imageViewTrailing = imageView?.snp.trailing {
                $0.leading.equalTo(imageViewTrailing).offset(12 * DesignSet.frameWidthRatio)
            }
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(18 * DesignSet.frameHeightRatio)
        }
        
        detailTextLabel?.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24 * DesignSet.frameWidthRatio)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    public func configure(with model: Penalty) {
        history = model
        textLabel?.text = history.nickname
        detailTextLabel?.text = "\(history.penalty)"
    }
}
