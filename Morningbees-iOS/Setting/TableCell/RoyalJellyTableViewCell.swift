//
//  RoyalJellyTableViewCell.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/22.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class RoyalJellyTableViewCell: UITableViewCell {
    
    static let identifier = "RoyalJellyTableViewCell"
    public var penalty = Penalty(nickname: "", userId: 0, penalty: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont(font: .systemMedium, size: 15)
        textLabel?.textColor = UIColor(red: 34, green: 34, blue: 34)
    
        detailTextLabel?.textColor = UIColor(red: 34, green: 34, blue: 34)
        detailTextLabel?.font = UIFont(font: .systemBold, size: 14)
        
        imageView?.image = UIImage(named: "profileImage")
        imageView?.layer.cornerRadius = CGFloat(18 * ToolSet.heightRatio)
        imageView?.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView?.snp.makeConstraints {
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.equalTo(36 * ToolSet.heightRatio)
            $0.height.equalTo(36 * ToolSet.heightRatio)
        }
        textLabel?.snp.makeConstraints {
            if let imageViewTrailing = imageView?.snp.trailing {
                $0.leading.equalTo(imageViewTrailing).offset(12 * ToolSet.widthRatio)
            }
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(18 * ToolSet.heightRatio)
        }
        detailTextLabel?.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24 * ToolSet.widthRatio)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(15 * ToolSet.heightRatio)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        if selected {
            backgroundColor = UIColor(red: 255, green: 251, blue: 232)
        } else {
            backgroundColor = .clear
        }
    }
    
    public func configure(with model: Penalty) {
        penalty = model
        textLabel?.text = penalty.nickname
        detailTextLabel?.text = ToolSet.integerToCommaNumberString(with: penalty.penalty)
    }
}
