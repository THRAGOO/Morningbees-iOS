//
//  MissionCreateViewController.swift
//  Morningbees-iOS
//
//  Created by Byeongjo Koo on 2020/05/09.
//  Copyright © 2020 JUN LEE. All rights reserved.
//

import UIKit

final class MissionCreateViewController: UIViewController, CustomAlert {
    
// MARK:- Properties
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(popToPrevious), for: .touchUpInside)
        return button
    }()
    private let viewTitleLabel: UILabel = {
        let label = DesignSet.initLabel(text: "미션 등록", letterSpacing: -0.3)
        label.font = DesignSet.fontSet(name: TextFonts.systemSemiBold.rawValue, size: 17)
        label.textColor = DesignSet.colorSet(red: 34, green: 34, blue: 34)
        label.textAlignment = .center
        return label
    }()
    private let completeButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 17)
        button.setTitleColor(DesignSet.colorSet(red: 246, green: 205, blue: 0), for: .normal)
        button.setTitleColor(DesignSet.colorSet(red: 204, green: 204, blue: 204), for: .disabled)
        button.addTarget(self, action: #selector(missionCreateRequest), for: .touchUpInside)
        return button
    }()
    
    private let missionTitleCommentLabel: UILabel = {
        let label = DesignSet.initLabel(text: "타이틀", letterSpacing: -0.6)
        label.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 15)
        label.textColor = DesignSet.colorSet(red: 119, green: 119, blue: 119)
        return label
    }()
    private let missionTitleTextField: UITextField = {
        let textField = UITextField()
        textField.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 17)
        textField.textColor = DesignSet.colorSet(red: 68, green: 68, blue: 68)
        return textField
    }()
    private let bottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = DesignSet.colorSet(red: 211, green: 211, blue: 211).cgColor
        return view
    }()
    
    private let missionPictureCommentLabel: UILabel = {
        let label = DesignSet.initLabel(text: "사진 업로드", letterSpacing: -0.6)
        label.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 15)
        label.textColor = DesignSet.colorSet(red: 119, green: 119, blue: 119)
        return label
    }()
    private let takePictureButton: UIButton = {
        let button = UIButton()
        button.setTitle("사진찍기", for: .normal)
        button.titleLabel?.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 15)
        button.setTitleColor(DesignSet.colorSet(red: 170, green: 170, blue: 170), for: .normal)
        button.backgroundColor = DesignSet.colorSet(red: 250, green: 250, blue: 250)
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(selectImageFromCamera), for: .touchUpInside)
        return button
    }()
    private let selectFromGalleryButton: UIButton = {
        let button = UIButton()
        button.setTitle("갤러리에서\n" + "가져오기", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 15)
        button.setTitleColor(DesignSet.colorSet(red: 170, green: 170, blue: 170), for: .normal)
        button.backgroundColor = DesignSet.colorSet(red: 250, green: 250, blue: 250)
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(selectImageFromLibary), for: .touchUpInside)
        return button
    }()
    private let selectedPictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    private let reloadIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iconReload")
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.3
        imageView.isHidden = true
        return imageView
    }()
    private let reloadPictureButton: UIButton = {
        let button = UIButton()
        button.setTitle("다시 올리기", for: .normal)
        button.setTitleColor(DesignSet.colorSet(red: 170, green: 170, blue: 170), for: .normal)
        button.titleLabel?.font = DesignSet.fontSet(name: TextFonts.systemSemiBold.rawValue, size: 14)
        button.addTarget(self, action: #selector(touchUpReloadButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private let difficultyCommentLabel: UILabel = {
        let label = DesignSet.initLabel(text: "난이도 설정", letterSpacing: -0.6)
        label.font = DesignSet.fontSet(name: TextFonts.systemBold.rawValue, size: 15)
        label.textColor = DesignSet.colorSet(red: 119, green: 119, blue: 119)
        return label
    }()
    private let difficultyDescriptionLabel: UILabel = {
        let label = DesignSet.initLabel(text: "설정값에 따라 벌금 액수가 달라집니다.", letterSpacing: -0.3)
        label.font = DesignSet.fontSet(name: TextFonts.systemMedium.rawValue, size: 13)
        label.textColor = DesignSet.colorSet(red: 170, green: 170, blue: 170)
        return label
    }()
    private let customSegmentedControl: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSet.colorSet(red: 242, green: 242, blue: 242)
        view.layer.cornerRadius = 18
        return view
    }()
    
    private var difficultyButtons = [UIButton]()
    private var selector: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSet.colorSet(red: 255, green: 218, blue: 34)
        view.isHidden = true
        view.layer.cornerRadius = 18
        return view
    }()
    
    private var imageName: String = ""
    private var difficulty: Int = 0
    
    private var isTitleSet: Bool = false
    private var isPictureSet: Bool = false
    private var isDifficulltySet: Bool = false
    
// MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupCustomSegmentedControlView()
        missionTitleTextField.delegate = self
    }
}

// MARK:- Navigation Control

extension MissionCreateViewController {
    
    @objc private func popToPrevious(_ sender: UIButton) {
        NavigationControl().popToPrevViewController()
    }
}

// MARK:- MissionCreate Request

extension MissionCreateViewController {
    
    @objc private func missionCreateRequest() {
        let beeID = UserDefaults.standard.integer(forKey: "beeID")
        let missionData = ["beeId": "\(beeID)",
                           "description": "test",
                           "type": "1",
                           "difficulty": "\(self.difficulty)"]
        guard let image = selectedPictureView.image,
              let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        KeychainService.extractKeyChainToken { (accessToken, _, error) in
            if let error = error {
                self.presentOneButtonAlert(title: "Token Error", message: error.localizedDescription)
            }
            guard let accessToken = accessToken else {
                return
            }
            
            let requestSet = RequestSet(method: .post, path: .missionCreate)
            let header = [RequestHeader.accessToken.rawValue: accessToken]
            
            MultipartFormdataRequest().request(parameters: missionData,
                                               imageData: imageData,
                                               requestSet: requestSet,
                                               header: header) { (created, error) in
                if let error = error {
                    self.presentOneButtonAlert(title: "Error!", message: error.localizedDescription)
                }
                if created {
                    self.presentOneButtonAlert(title: "Success!", message: "Successfully Created Mission!") {
                        NavigationControl().popToPrevViewController()
                    }
                } else {
                    self.presentOneButtonAlert(title: "Failed!",
                                               message: "Mission already created or Something went wrong!") {
                        NavigationControl().popToPrevViewController()
                    }
                }
            }
        }
    }
}

// MARK:- Complete Button Control

extension MissionCreateViewController {
    
    private func completeButtonControl() {
        if isTitleSet && isPictureSet && isDifficulltySet {
            completeButton.isEnabled = true
        } else {
            completeButton.isEnabled = false
        }
    }
}

// MARK:- TextField Handling

extension MissionCreateViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        missionTitleTextField.endEditing(true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if missionTitleTextField.text != "" {
            isTitleSet = true
            completeButtonControl()
        } else {
            isTitleSet = false
            completeButtonControl()
        }
    }
}

// MARK:- Image Picker

extension MissionCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func hideImagePickerSection(_ state: Bool) {
        selectFromGalleryButton.isHidden = state
        takePictureButton.isHidden = state
        selectedPictureView.isHidden = !state
        reloadPictureButton.isHidden = !state
        reloadIcon.isHidden = !state
    }
    
    @objc private func selectImageFromLibary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func selectImageFromCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isPictureSet = false
        selectedPictureView.image = nil
        completeButtonControl()
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        selectedPictureView.image = selectedImage
        isPictureSet = true
        completeButtonControl()
        hideImagePickerSection(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func touchUpReloadButton(_ sender: UIButton) {
        hideImagePickerSection(false)
        isPictureSet = false
        selectedPictureView.image = nil
        completeButtonControl()
    }
}

// MARK:- Segmented Control

extension MissionCreateViewController {
    
    private func setupSegmentControlButton(title: String) {
        let button = UIButton.init(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(DesignSet.colorSet(red: 204, green: 204, blue: 204), for: .normal)
        button.setTitleColor(DesignSet.colorSet(red: 68, green: 68, blue: 68), for: .selected)
        button.tintColor = .clear
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didSegControlTapped), for: .touchUpInside)
        difficultyButtons.append(button)
    }
    
    private func setupCustomSegmentedControlView() {
        setupSegmentControlButton(title: "상\n" + "-1,000원")
        setupSegmentControlButton(title: "중\n" + "기본값")
        setupSegmentControlButton(title: "하\n" + "+1,000원")
        customSegmentedControl.addSubview(selector)
        DesignSet.constraints(view: selector, top: 0, leading: 0, height: 96, width: 109)
        let stackView = UIStackView.init(arrangedSubviews: difficultyButtons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        customSegmentedControl.addSubview(stackView)
        DesignSet.constraints(view: stackView, top: 0, leading: 0, height: 96, width: 327)
        customSegmentedControl.layer.zPosition = 0
        selector.layer.zPosition = 1
        stackView.layer.zPosition = 2
    }
    
    @objc private func didSegControlTapped(_ sender: UIButton) {
        guard let difficultyIndex = difficultyButtons.firstIndex(of: sender) else {
            return
        }
        difficulty = 2 - difficultyIndex
        isDifficulltySet = true
        completeButtonControl()
        for (buttonIndex, btn) in difficultyButtons.enumerated() {
            btn.isSelected = false
            if btn == sender {
                btn.isSelected = true
                let width = customSegmentedControl.frame.width
                let selectorStartPosition = width / CGFloat(difficultyButtons.count) * CGFloat(buttonIndex)
                if selector.isHidden {
                    selector.isHidden = false
                    self.selector.frame.origin.x = selectorStartPosition
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.selector.frame.origin.x = selectorStartPosition
                })
            }
        }
    }
}

// MARK:- View Design

extension MissionCreateViewController {
    
    private func setupDesign() {
        view.addSubview(toPreviousButton)
        view.addSubview(viewTitleLabel)
        view.addSubview(completeButton)
        
        view.addSubview(missionTitleCommentLabel)
        view.addSubview(missionTitleTextField)
        view.addSubview(bottomlineView)
        
        view.addSubview(missionPictureCommentLabel)
        view.addSubview(takePictureButton)
        view.addSubview(selectFromGalleryButton)
        view.addSubview(selectedPictureView)
        view.addSubview(reloadPictureButton)
        view.addSubview(reloadIcon)
        
        view.addSubview(difficultyCommentLabel)
        view.addSubview(difficultyDescriptionLabel)
        view.addSubview(customSegmentedControl)
        
        DesignSet.constraints(view: toPreviousButton, top: 37, leading: 24, height: 20, width: 12)
        DesignSet.constraints(view: viewTitleLabel, top: 38, leading: 150, height: 20, width: 76)
        DesignSet.flexibleConstraints(view: completeButton, top: 38, leading: 319, height: 20, width: 35)
        
        DesignSet.flexibleConstraints(view: missionTitleCommentLabel, top: 92, leading: 24, height: 19, width: 38)
        DesignSet.constraints(view: missionTitleTextField, top: 127, leading: 24, height: 20, width: 327)
        DesignSet.constraints(view: bottomlineView, top: 161, leading: 24, height: 1, width: 327)
        
        DesignSet.flexibleConstraints(view: missionPictureCommentLabel, top: 216, leading: 24, height: 19, width: 66)
        DesignSet.constraints(view: takePictureButton, top: 256, leading: 54, height: 120, width: 120)
        DesignSet.constraints(view: selectFromGalleryButton, top: 256, leading: 198, height: 120, width: 120)
        DesignSet.constraints(view: selectedPictureView, top: 256, leading: 24, height: 120, width: 120)
        DesignSet.flexibleConstraints(view: reloadPictureButton, top: 360, leading: 183, height: 17, width: 60)
        DesignSet.constraints(view: reloadIcon, top: 358, leading: 159, height: 18, width: 17)
        
        DesignSet.flexibleConstraints(view: difficultyCommentLabel, top: 439, leading: 24, height: 19, width: 66)
        DesignSet.flexibleConstraints(view: difficultyDescriptionLabel, top: 463, leading: 24, height: 16, width: 191)
        DesignSet.constraints(view: customSegmentedControl, top: 498, leading: 24, height: 96, width: 327)
    }
}
