//
//  RootViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2021/02/21.
//  Copyright © 2021 THRAGOO. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pushToStartViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NavigationControl.navigationController.interactivePopGestureRecognizer?.delegate = self
    }
}

extension RootViewController {
    
    // MARK:- Auto SignIn
    
    private func pushToStartViewController() {
        MeAPI().request { (alreadyJoinedBee, error) in
            if let _ = error {
                NavigationControl.pushToSignInViewController()
            }
            guard let alreadyJoinedBee = alreadyJoinedBee else {
                return
            }
            if alreadyJoinedBee {
                NavigationControl.pushToBeeMainViewController()
            } else {
                NavigationControl.pushToBeforeJoinViewController()
            }
        }
    }
}
