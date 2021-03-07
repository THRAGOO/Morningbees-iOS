//
//  MemberTableCell.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/01/09.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class MemberTableViewCell: UITableViewCell {
    
    static let identifier = "MemberTableViewCell"
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 255, green: 239, blue: 158)
        return imageView
    }()
    private let nicknameLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: 0)
        label.font = UIFont(font: .systemMedium, size: 15)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        label.textAlignment = .left
        return label
    }()
    private let queenMarkImageView = UIImageView(imageName: "crown")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(queenMarkImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(25 * ToolSet.widthRatio)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(36 * ToolSet.widthRatio)
            $0.width.equalTo(36 * ToolSet.widthRatio)
        }
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12 * ToolSet.widthRatio)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(18 * ToolSet.widthRatio)
            $0.width.greaterThanOrEqualTo(171 * ToolSet.widthRatio)
        }
        queenMarkImageView.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).offset(-24 * ToolSet.widthRatio)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(18 * ToolSet.widthRatio)
            $0.width.equalTo(20 * ToolSet.widthRatio)
        }
    }
    
    func configure(with model: Profile) {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 241, green: 241, blue: 241).cgColor
        guard let queenBee = UserDefaults.standard.string(forKey: UserDefaultsKey.queenBee.rawValue) else {
            return
        }
        nicknameLabel.text = model.nickname
        if model.nickname != queenBee {
            queenMarkImageView.isHidden = true
        } else {
            queenMarkImageView.isHidden = false
        }
    }
}
