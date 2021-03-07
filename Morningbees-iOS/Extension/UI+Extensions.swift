//
//  UI+Extension.swift
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

enum ToolSet {
    
    static let heightRatio = Double(UIViewController().view.frame.height) / StandardDevice.height.rawValue
    static let widthRatio = Double(UIViewController().view.frame.width) / StandardDevice.width.rawValue
}

extension ToolSet {
    
    /// Convert Int to comma number string
    static func integerToCommaNumberString(with value: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let convertedValue = numberFormatter.string(from: NSNumber(value: value)) else {
            return ""
        }
        return convertedValue
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

// MARK:- UIView Layer ConerRadius with view ratio

extension UIView {
    
    public func setRatioCornerRadius(_ value: Double) {
        layer.cornerRadius = CGFloat(ToolSet.heightRatio * value)
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
                                      value: CGFloat(letterSpacing * ToolSet.heightRatio),
                                      range: NSRange.init(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}

// MARK: Date Override

extension Date {
    
    static var tomorrow: Date = {
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else {
            return Date.init(timeIntervalSinceNow: 24 * 60 * 60)
        }
        return tomorrow
    }()
}
