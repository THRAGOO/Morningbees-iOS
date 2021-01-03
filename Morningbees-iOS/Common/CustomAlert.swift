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
    func presentOneButtonAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
            guard let completion = completion else {
                self.viewController.present(alertController, animated: true)
                return
            }
            self.viewController.present(alertController, animated: true, completion: completion)
        }
    }
}
