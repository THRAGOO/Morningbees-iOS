//
//  DesignSet.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/02/26.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import Kingfisher
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
            $0.width.equalTo(width * frameWidthRatio)
        }
    }
}

// MARK:- UIButton Backgroundcolor for status

extension UIButton {
    public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
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

// MARK:- UIColor Override

extension UIColor {
    
    convenience init(red: Double, green: Double, blue: Double) {
        self.init(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1)
    }
}

// MARK:- UIFont Override

extension UIFont {
    convenience init?(font: TextFonts, size: CGFloat) {
        self.init(name: font.rawValue, size: size)
    }
}

extension UIView {
    public func setRatioCornerRadius(_ value: Double) {
        layer.cornerRadius = CGFloat(DesignSet.frameHeightRatio * value)
    }
}

// MARK:- UIImageView Override

extension UIImageView {
    
    convenience init(imageName: String) {
        self.init(image: UIImage(named: imageName))
        self.contentMode = .scaleAspectFill
    }
    
    // MARK: Kingfisher Image Caching
    
    public func setImage(with imageUrlString: String) {
        self.kf.indicatorType = .activity
        ImageCache.default.retrieveImage(forKey: imageUrlString) { result in
            switch result {
            case .success(let cache):
                if let image = cache.image {
                    self.image = image
                } else {
                    guard let imageUrl = URL(string: imageUrlString) else {
                        return
                    }
                    let source = ImageResource(downloadURL: imageUrl, cacheKey: imageUrlString)
                    self.kf.setImage(with: source)
                }
            case .failure(let error):
                print(error.errorDescription?.debugDescription ?? "")
            }
        }
    }
}

// MARK:- UILabel Override

extension UILabel {
    
    convenience init(text: String, letterSpacing: Double) {
        self.init()
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: CGFloat(letterSpacing * DesignSet.frameHeightRatio),
                                      range: NSRange.init(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}
