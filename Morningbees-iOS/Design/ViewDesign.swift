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
    case systemBold = "AppleSDGothicNeo-Bold"
    case systemSemiBold = "AppleSDGothicNeo-SemiBold"
    case systemMedium = "AppleSDGothicNeo-Medium"
    case systemRegular = "AppleSDGothicNeo-Regular"
    case systemExtraBold = "AppleSDGothicNeo-ExtraBold"
}

final class DesignSet {
    
// MARK:- Properties
    
    static let frameHeightRatio = Double(UIViewController().view.frame.height) / StandardDevice.height.rawValue
    static let frameWidthRatio = Double(UIViewController().view.frame.width) / StandardDevice.width.rawValue
}

extension DesignSet {
    
    static func colorSet(red: Double, green: Double, blue: Double) -> UIColor {
        return UIColor(red: CGFloat(red/255.0),
                       green: CGFloat(green/255.0),
                       blue: CGFloat(blue/255.0),
                       alpha: CGFloat(1.0))
    }
    
    static func fontSet(name: String, size: Double) -> UIFont {
        guard let font = UIFont.init(name: name, size: CGFloat(size * frameHeightRatio)) else {
            fatalError("Failed to load the font.")
        }
        return font
    }
    
    // MARK: Initializer
    
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
                                      value: CGFloat(letterSpacing * frameHeightRatio),
                                      range: NSRange.init(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        label.isUserInteractionEnabled = false
        return label
    }
    
    // MARK: Constraints
    
    static func constraints(view: UIView, top: Double, leading: Double, height: Double, width: Double) {
        view.snp.makeConstraints {
            $0.top.equalTo(top * frameHeightRatio)
            $0.leading.equalTo(leading * frameWidthRatio)
            $0.height.equalTo(height * frameHeightRatio)
            $0.width.equalTo(width * frameWidthRatio)
        }
    }
    
    static func flexibleConstraints(view: UIView, top: Double, leading: Double, height: Double, width: Double) {
        view.snp.makeConstraints {
            $0.top.equalTo(top * frameHeightRatio)
            $0.leading.equalTo(leading * frameWidthRatio)
            $0.height.equalTo(height * frameHeightRatio)
            $0.width.greaterThanOrEqualTo(width * frameWidthRatio)
        }
    }
    
    static func squareConstraints(view: UIView, top: Double, leading: Double, height: Double, width: Double) {
        view.snp.makeConstraints {
            $0.top.equalTo(top * frameHeightRatio)
            $0.leading.equalTo(leading * frameWidthRatio)
            $0.height.equalTo(height * frameWidthRatio)
            $0.width.greaterThanOrEqualTo(width * frameWidthRatio)
        }
    }
}

// MARK:- UIButton Backgroundcolor Set

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
