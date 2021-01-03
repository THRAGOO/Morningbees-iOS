//
//  BeeCreateJellyViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/04/13.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

class BeeCreateJellyViewController: UIViewController {
    
    // MARK:- Properties
    
    private let jellySelectImg = DesignSet.initImageView(imgName: "btnJellyStartPointSelect")
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(popToPrevious), for: .touchUpInside)
        return button
    }()
    
    private let firstDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "로얄 젤리를", letterSpacing: -0.5)
        label.textColor = DesignSet.colorSet(red: 34, green: 34, blue: 34)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 24)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let secondDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "설정해 주세요.", letterSpacing: -0.5)
        label.textColor = DesignSet.colorSet(red: 34, green: 34, blue: 34)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 24)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let firstDetailDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "'로열젤리'는 모닝비즈 내 벌금이에요.", letterSpacing: -0.5)
        label.textColor = DesignSet.colorSet(red: 204, green: 204, blue: 204)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 13)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let secondDetailDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "매일 진행되는 미션을 수행하지 못한 꿀벌에게 부과해요.", letterSpacing: -0.5)
        label.textColor = DesignSet.colorSet(red: 204, green: 204, blue: 204)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 13)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let jellyDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "로얄젤리 (최소2,000~최대 10,000원)", letterSpacing: 0)
        label.textColor = DesignSet.colorSet(red: 119, green: 119, blue: 119)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let customSegmentedControl: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSet.colorSet(red: 245, green: 245, blue: 245)
        view.layer.cornerRadius = 9
        return view
    }()
    
    private let curRoyalJellyLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSet.colorSet(red: 68, green: 68, blue: 68)
        label.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 13)
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    private let minRoyalJellyLabel: UILabel = {
        let label = UILabel()
        label.text = "2,000"
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 13)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let maxRoyalJellyLabel: UILabel = {
        let label = UILabel()
        label.text = "10,000"
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 13)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSet.colorSet(red: 229, green: 229, blue: 229)
        button.isEnabled = false
        button.setTitle("다음 3/3", for: .normal)
        button.setTitleColor(DesignSet.colorSet(red: 255, green: 255, blue: 255), for: .normal)
        button.titleLabel?.font =  DesignSet.fontSet(name: TextFonts.systemSemiBold.rawValue, size: 15)
        button.addTarget(self, action: #selector(touchUpNextButton), for: .touchUpInside)
        return button
    }()
    
    private var jellyButtons = [UIButton]()
    private var selector = UIView()
    
    private let beeYellow = DesignSet.colorSet(red: 255, green: 218, blue: 34)
    private let selectedJellyColor = DesignSet.colorSet(red: 68, green: 68, blue: 68)
    private let notSelectedJellyColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
    
    private let selectedJellyFont = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 13)
    private let notSelectedJellyFont = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 13)
    
    var beeName: String = ""
    var startTime: Int = 0
    var endTime: Int = 0
    var royalJelly: Int = 0
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupCustomSegmentedControlView()
    }
}

// MARK:- Navigation Control

extension BeeCreateJellyViewController {
    
    @objc private func touchUpNextButton(_ sender: UIButton) {
        beeCreateRequest()
    }
    
    @objc private func popToPrevious(_ sender: UIButton) {
        NavigationControl().popToPrevViewController()
    }
}

// MARK:- Segmented Control

extension BeeCreateJellyViewController {
    
    private func setupCustomSegmentedControlView() {
        for _ in 0..<9 {
            let button = UIButton.init(type: .system)
            button.setTitle("•", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.setTitleColor(DesignSet.colorSet(red: 220, green: 220, blue: 220), for: .normal)
            button.titleLabel?.textAlignment = .center
            button.addTarget(self, action: #selector(didSegControlTapped), for: .touchUpInside)
            jellyButtons.append(button)
        }
        
        let selectorWidth = customSegmentedControl.frame.width / CGFloat(9)
        selector = UIView.init(frame: CGRect.init(x: 0,
                                                  y: 0,
                                                  width: selectorWidth,
                                                  height: customSegmentedControl.frame.height))
        customSegmentedControl.addSubview(selector)
        selector.addSubview(jellySelectImg)
        DesignSet.constraints(view: jellySelectImg, top: -3, leading: 6.5, height: 24, width: 24)
        jellySelectImg.isHidden = true
        
        let stackView = UIStackView.init(arrangedSubviews: jellyButtons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        customSegmentedControl.addSubview(stackView)
        DesignSet.constraints(view: stackView, top: 0, leading: 0, height: 18, width: 327)
        
        customSegmentedControl.layer.zPosition = 0
        selector.layer.zPosition = 1
    }
    
    private func segmentValueSet(min: Bool, max: Bool, cur: Bool) {
        
        minRoyalJellyLabel.textColor = min ? selectedJellyColor : notSelectedJellyColor
        minRoyalJellyLabel.font = min ? selectedJellyFont : notSelectedJellyFont
        
        maxRoyalJellyLabel.textColor = max ? selectedJellyColor : notSelectedJellyColor
        maxRoyalJellyLabel.font = max ? selectedJellyFont : notSelectedJellyFont
        
        curRoyalJellyLabel.isHidden = cur ? false : true
    }
    
    @objc private func didSegControlTapped(_ sender: UIButton) {
        nextButton.isEnabled = true
        nextButton.backgroundColor = beeYellow
        nextButton.setTitle("Bee 시작하기", for: .normal)
        nextButton.setTitleColor(DesignSet.colorSet(red: 34, green: 34, blue: 34), for: .normal)
        guard let jellyIndex = jellyButtons.firstIndex(of: sender) else {
            return
        }
        // 2천원부터 시작이니까 +2
        royalJelly = (jellyIndex + 2)
        if royalJelly == 2 {
            segmentValueSet(min: true, max: false, cur: false)
        } else if royalJelly == 10 {
            segmentValueSet(min: false, max: true, cur: false)
        } else {
            segmentValueSet(min: false, max: false, cur: true)
            curRoyalJellyLabel.text = String(royalJelly) + ",000"
        }

        for (buttonIndex, btn) in jellyButtons.enumerated() {
            if btn == sender {
                let width = customSegmentedControl.frame.width
                let selectorStartPosition = width / CGFloat(jellyButtons.count) * CGFloat(buttonIndex)
                // 컨트롤 밑에 숫자 움직이는 거 컨트롤!
                let jellyStartPosition = CGFloat(Double(36 * jellyIndex) * DesignSet.frameWidthRatio)
                if jellySelectImg.isHidden {
                    selector.frame.origin.x = selectorStartPosition
                    self.curRoyalJellyLabel.transform = CGAffineTransform(translationX: +jellyStartPosition, y: 0)
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.jellySelectImg.isHidden = false
                    self.selector.frame.origin.x = selectorStartPosition
                    self.curRoyalJellyLabel.transform = .identity
                    self.curRoyalJellyLabel.transform = CGAffineTransform(translationX: +jellyStartPosition, y: 0)
                })
            }
        }
        royalJelly *= 1000
    }
}

// MARK:- Bee Create Request

extension BeeCreateJellyViewController: CustomAlert {
    
    func beeCreateRequest() {
        let reqModel = BeeCreateModel()
        let request = RequestSet(method: reqModel.method, path: reqModel.path)
        let beeCreate = Request<BeeCreate>()
        let param = BeeCreateParam(title: self.beeName,
                                   startTime: self.startTime,
                                   endTime: self.endTime,
                                   pay: self.royalJelly,
                                   description: "")
        KeychainService.extractKeyChainToken { (accessToken, _, error) in
            if let error = error {
                self.presentOneButtonAlert(title: "Token Error", message: error.localizedDescription)
            }
            guard let accessToken = accessToken else {
                return
            }
            let header: [String: String] = [RequestHeader.accessToken.rawValue: accessToken]
            beeCreate.request(req: request, header: header, param: param) { (_, created, error) in
                if let error = error {
                    self.presentOneButtonAlert(title: "BeeCreate", message: error.localizedDescription)
                    return
                }
                if created {
                    self.presentOneButtonAlert(title: "BeeCreate", message: "Successfully created bee!")
                    
                    MeAPI().request { (alreadyJoinBee, error) in
                        if let error = error {
                            self.presentOneButtonAlert(title: "BeeCreate", message: error.localizedDescription)
                            return
                        }
                        guard let alreadyJoinBee = alreadyJoinBee else {
                            return
                        }
                        if alreadyJoinBee {
                            NavigationControl().pushToBeeMainViewController()
                        } else {
                            NavigationControl().pushToBeforeJoinViewController()
                        }
                    }
                }
            }
        }
    }
}

// MARK:- Design Set

extension BeeCreateJellyViewController {
    
    private func setupDesign() {
        view.addSubview(toPreviousButton)
        
        view.addSubview(firstDescriptionLabel)
        view.addSubview(secondDescriptionLabel)
        
        view.addSubview(jellyDescriptionLabel)
        view.addSubview(customSegmentedControl)
        
        view.addSubview(customSegmentedControl)
        
        view.addSubview(minRoyalJellyLabel)
        view.addSubview(maxRoyalJellyLabel)
        view.addSubview(curRoyalJellyLabel)
        
        view.addSubview(nextButton)
        
        DesignSet.constraints(view: toPreviousButton, top: 42, leading: 24, height: 20, width: 12)
        
        DesignSet.constraints(view: firstDescriptionLabel, top: 90, leading: 24, height: 33, width: 153)
        DesignSet.constraints(view: secondDescriptionLabel, top: 123, leading: 24, height: 33, width: 153)
        
        DesignSet.constraints(view: jellyDescriptionLabel, top: 223, leading: 24, height: 17, width: 235)
        DesignSet.constraints(view: customSegmentedControl, top: 271, leading: 24, height: 18, width: 327)
        
        DesignSet.constraints(view: minRoyalJellyLabel, top: 301, leading: 20, height: 16, width: 35)
        DesignSet.constraints(view: maxRoyalJellyLabel, top: 301, leading: 317, height: 16, width: 41)
        DesignSet.constraints(view: curRoyalJellyLabel, top: 301, leading: 26, height: 16, width: 36)
        
        DesignSet.constraints(view: nextButton, top: 611, leading: 0, height: 56, width: 375)
    }
}
