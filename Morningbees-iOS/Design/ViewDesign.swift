//
//  DesignSet.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/02/26.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit
import SnapKit

enum StandardDevice: Double {
    case width = 375.0
    case height = 667.0
}

enum TextFonts: String {
    case naverFont = "NanumBarunGothicBold"
    case googleFont = "Roboto-Medium"
}

final class DesignSet {
    
//MARK:- Properties
    
    static let frameHeight = Double(UIViewController().view.frame.height)
    static let frameWidth = Double(UIViewController().view.frame.width)
}

extension DesignSet {
    
    static func colorSet(red: Double, green: Double, blue: Double) -> UIColor {
        return UIColor(red: CGFloat(red/255.0),
                       green: CGFloat(green/255.0),
                       blue: CGFloat(blue/255.0),
                       alpha: CGFloat(1.0))
    }
    
    //MARK: Initializer
    
    static func initImageView(imgName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imgName)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    static func initLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    //MARK: Constraints
    
    static func constraints(view: UIView, top: Double, leading: Double, height: Double, width: Double) {
        view.snp.makeConstraints {
            $0.top.equalTo((top / StandardDevice.height.rawValue) * frameHeight)
            $0.leading.equalTo((leading / StandardDevice.width.rawValue) * frameWidth)
            $0.height.equalTo((height / StandardDevice.height.rawValue) * frameHeight)
            $0.width.equalTo((width / StandardDevice.width.rawValue) * frameWidth)
        }
    }
}
