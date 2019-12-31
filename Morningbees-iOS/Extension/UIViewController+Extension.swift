//
//  UIViewController+Extension.swift
//  Morningbees-iOS
//
//  Created by JUN LEE on 2019/12/28.
//  Copyright © 2019 JUN LEE. All rights reserved.
//

import UIKit

// Swizzling
extension UIViewController {
    static let swizzle: Void = {
        let originalSelectors = [
            #selector(viewDidLoad),
            #selector(viewWillAppear),
            #selector(viewDidAppear),
            #selector(viewWillDisappear),
            #selector(viewDidDisappear)
        ]

        let swizzleSelectors = [
            #selector(swizzleViewDidLoad),
            #selector(swizzleViewWillAppear),
            #selector(swizzleViewDidAppear),
            #selector(swizzleViewWillDisappear),
            #selector(swizzleViewDidDisappear)
        ]

        let originalMethods = originalSelectors.compactMap { class_getInstanceMethod(UIViewController.self, $0) }
        let swizzleMethods = swizzleSelectors.compactMap { class_getInstanceMethod(UIViewController.self, $0) }

        for (original, swizzle) in zip(originalMethods, swizzleMethods) {
            method_exchangeImplementations(original, swizzle)
        }
    }()

    @objc
    private func swizzleViewDidLoad() {
        Logger.debug("\(String(describing: self)) ViewDidLoad")

        let deallocator = Deallocator { Logger.debug("\(String(describing: self)) deinit") }
        var associatedObjectAddr = ""
        objc_setAssociatedObject(self, &associatedObjectAddr, deallocator, .OBJC_ASSOCIATION_RETAIN)
    }

    @objc
    private func swizzleViewWillAppear(_ animated: Bool) {
        Logger.debug("\(String(describing: self)) ViewWillAppear")
    }

    @objc
    private func swizzleViewDidAppear(_ animated: Bool) {
        Logger.debug("\(String(describing: self)) ViewDidAppear")
    }

    @objc
    private func swizzleViewWillDisappear(_ animated: Bool) {
        Logger.debug("\(String(describing: self)) ViewWillDisappear")
    }

    @objc
    private func swizzleViewDidDisappear(_ animated: Bool) {
        Logger.debug("\(String(describing: self)) ViewDidDisappear")
    }
}

final class Deallocator {
    let closure: () -> Void

    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }

    deinit {
        closure()
    }
}
