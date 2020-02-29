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
    case SFProDisplayBlack = "SFProDisplay-Black"
    case appleSDGothicNeoBold = "AppleSDGothicNeo-Bold"
    case appleSDGothicNeoSemiBold = "AppleSDGothicNeo-SemiBold"
    case appleSDGothicNeoMedium = "AppleSDGothicNeo-Medium"
    case appleSDGothicNeoRegular = "AppleSDGothicNeo-Regular"
    case appleSDGothicNeoExtraBold = "AppleSDGothicNeo-ExtraBold"
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
    
    static func fontSet(name: String, size: Double) -> UIFont {
        guard let font = UIFont.init(name: name,
                                     size: CGFloat((size / StandardDevice.height.rawValue) * frameHeight)) else {
                                    fatalError("Failed to load the font.")
        }
        return font
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
    
    static func initLabel(text: String, letterSpacing: Double) -> UILabel {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: CGFloat((letterSpacing / StandardDevice.height.rawValue) * frameHeight),
                                      range: NSRange.init(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        label.isUserInteractionEnabled = false
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
    
    static func flexibleConstraints(view: UIView, top: Double, leading: Double, height: Double, width: Double) {
        view.snp.makeConstraints {
            $0.top.equalTo((top / StandardDevice.height.rawValue) * frameHeight)
            $0.leading.equalTo((leading / StandardDevice.width.rawValue) * frameWidth)
            $0.height.equalTo((height / StandardDevice.height.rawValue) * frameHeight)
            $0.width.greaterThanOrEqualTo((width / StandardDevice.width.rawValue) * frameWidth)
        }
    }
}
