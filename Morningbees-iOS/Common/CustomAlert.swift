//
//  CustomAlert.swift
//  Morningbees-iOS
//
//  Created by iiwii on 2020/01/11.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

protocol CustomAlert: NSObjectProtocol {
    
    var viewController: UIViewController { get }
}

extension CustomAlert where Self: UIViewController {
    
    var viewController: UIViewController {
        return self
    }
}

extension CustomAlert {
    
    func presentConfirmAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: handler))
            self.viewController.present(alertController, animated: true)
        }
    }
    
    func presentYesNoAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "아니요", style: .destructive, handler: nil))
            alertController.addAction(UIAlertAction(title: "네", style: .default, handler: handler))
            self.viewController.present(alertController, animated: true)
        }
    }
}
