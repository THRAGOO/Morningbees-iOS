//
//  BCStepThrViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/13.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

class BCStepThrViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet private weak var beeNameLabel: UILabel!
    @IBOutlet private weak var missionTime: UILabel!
    @IBOutlet private weak var royalJellySegmentedControl: UISegmentedControl!
    
    var beeName: String = ""
    var startTime: Int = 0
    var endTime: Int = 0
    var royalJelly: Int = 0
    
    private let curRoyalJellyLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    private let minRoyalJellyLabel: UILabel = {
        let label = UILabel()
        label.text = "2,000"
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let maxRoyalJellyLabel: UILabel = {
        let label = UILabel()
        label.text = "10,000"
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let nextBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(touchUpNextBtn), for: .touchUpInside)
        return button
    }()
    private let btnLabel: UILabel = {
        let label = UILabel()
        label.text = "다음 3/3"
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        beeNameLabel?.text = beeName
        missionTime?.text = String(startTime) + " - " + String(endTime)
    }
    
}

//MARK:- Segmented Control

extension BCStepThrViewController {
    
    private func segmentValueSet(min: Bool, max: Bool, cur: Bool) {
        if min {
            minRoyalJellyLabel.textColor = .black
            minRoyalJellyLabel.font = .boldSystemFont(ofSize: 16)
        } else {
            minRoyalJellyLabel.textColor = .lightGray
            minRoyalJellyLabel.font = .none
        }
        if max {
            maxRoyalJellyLabel.textColor = .black
            maxRoyalJellyLabel.font = .boldSystemFont(ofSize: 16)
        } else {
            maxRoyalJellyLabel.textColor = .lightGray
            maxRoyalJellyLabel.font = .none
        }
        if cur {
            curRoyalJellyLabel.isHidden = false
        } else {
            curRoyalJellyLabel.isHidden = true
        }
    }
    
    @IBAction private func didSegControlChaged(_ sender: UISegmentedControl) {
        nextBtn.isEnabled = true
        nextBtn.backgroundColor = .yellow
        btnLabel.text = "Bee 시작하기"
        btnLabel.textColor = .black
        
        royalJelly = sender.selectedSegmentIndex + 2
        let count = sender.selectedSegmentIndex - 1
        if royalJelly == 2 {
            segmentValueSet(min: true, max: false, cur: false)
        } else if royalJelly == 10 {
            segmentValueSet(min: false, max: true, cur: false)
        } else {
            segmentValueSet(min: false, max: false, cur: true)
            curRoyalJellyLabel.text = String(royalJelly) + ",000"
            curRoyalJellyLabel.font = .boldSystemFont(ofSize: 16)
            curRoyalJellyLabel.transform = .identity
            curRoyalJellyLabel.transform = CGAffineTransform(translationX: +CGFloat(36 * count), y: 0)
        }
        royalJelly *= 1000
    }
}

//MARK:- Bee Create Request

extension BCStepThrViewController: CustomAlert {
    
    func beeCreateRequest() {
        let reqModel = CreateBeeModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let createBee = Request<CreateBee>()
        KeychainService.extractKeyChainToken { (accessToken, _, error) in
            if let error = error {
                self.presentOneBtnAlert(title: "Token Error", message: error.localizedDescription)
            }
            guard let accessToken = accessToken else {
                return
            }
            let header: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            createBee.request(req: request, header: header, param: BeeCreateParam(title: self.beeName,
                                                                                  startTime: self.startTime,
                                                                                  endTime: self.endTime,
                                                                                  pay: self.royalJelly,
                                                                                  description: "")) { (_, error) in
                if let error = error {
                    self.presentOneBtnAlert(title: "BeeCreate", message: error.localizedDescription)
                    return
                }
                                                                                    
                NavigationControl().pushToBeeViewController()
            }
        }
    }
}

//MARK:- Navigation Control

extension BCStepThrViewController {
    
    @objc private func touchUpNextBtn(_ sender: UIButton) {
        beeCreateRequest()
    }
    
    @IBAction private func popToPrevious(_ sender: UIButton) {
        NavigationControl().popToPrevViewController()
    }
}

//MARK:- Design Set

extension BCStepThrViewController {
    
    private func setupDesign() {
        view.addSubview(minRoyalJellyLabel)
        view.addSubview(maxRoyalJellyLabel)
        view.addSubview(curRoyalJellyLabel)
        view.addSubview(nextBtn)
        nextBtn.addSubview(btnLabel)
        
        DesignSet.constraints(view: minRoyalJellyLabel, top: 285, leading: 20, height: 16, width: 35)
        DesignSet.constraints(view: maxRoyalJellyLabel, top: 285, leading: 317, height: 16, width: 41)
        DesignSet.constraints(view: curRoyalJellyLabel, top: 285, leading: 60, height: 16, width: 36)
        DesignSet.constraints(view: nextBtn, top: 611, leading: 0, height: 56, width: 375)
        DesignSet.constraints(view: btnLabel, top: 19, leading: 88, height: 19, width: 200)
    }
}
