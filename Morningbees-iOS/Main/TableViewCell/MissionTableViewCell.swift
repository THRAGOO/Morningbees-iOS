//
//  MissionTableViewCell.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/24.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class MissionTableViewCell: UITableViewCell {
    
    static let identifier = "MissionTableViewCell"
    
    private let profileImgaeview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = CGFloat(15 * DesignSet.frameHeightRatio)
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 229, green: 229, blue: 229)
        return imageView
    }()
    private let missionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 229, green: 229, blue: 229)
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont(font: .systemSemiBold, size: 13)
        textLabel?.textColor = UIColor(red: 34, green: 34, blue: 34)
        
        detailTextLabel?.font = UIFont(font: .systemSemiBold, size: 12)
        detailTextLabel?.textColor = UIColor(red: 204, green: 204, blue: 204)
        
        contentView.addSubview(profileImgaeview)
        contentView.addSubview(missionImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImgaeview.snp.makeConstraints {
            $0.top.equalTo(15 * DesignSet.frameWidthRatio)
            $0.leading.equalTo(25 * DesignSet.frameWidthRatio)
            $0.height.equalTo(30 * DesignSet.frameHeightRatio)
            $0.width.equalTo(30 * DesignSet.frameHeightRatio)
        }
        
        textLabel?.snp.makeConstraints {
            $0.top.equalTo(15 * DesignSet.frameWidthRatio)
            $0.leading.equalTo(profileImgaeview.snp.trailing).offset(9 * DesignSet.frameWidthRatio)
            $0.height.equalTo(15 * DesignSet.frameHeightRatio)
        }
        detailTextLabel?.snp.makeConstraints {
            $0.top.equalTo(33 * DesignSet.frameWidthRatio)
            $0.leading.equalTo(profileImgaeview.snp.trailing).offset(9 * DesignSet.frameWidthRatio)
            $0.height.equalTo(15 * DesignSet.frameHeightRatio)
        }
        
        missionImageView.snp.makeConstraints {
            $0.top.equalTo(60 * DesignSet.frameWidthRatio)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.height.equalTo(407 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
    }
    
    public func configure(with model: Missions) {
        textLabel?.text = model.nickname
        detailTextLabel?.text = model.createdAt
        missionImageView.setImage(with: model.imageUrl)
    }
}
