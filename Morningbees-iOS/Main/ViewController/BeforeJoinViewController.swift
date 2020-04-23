//
//  BeforeJoinViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/01.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

class BeforeJoinViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

extension BeforeJoinViewController {
    
    @IBAction func touchupBeeCreateBtn(_ sender: UIButton) {
        NavigationControl().pushToBCStepOneViewController()
    }
}
