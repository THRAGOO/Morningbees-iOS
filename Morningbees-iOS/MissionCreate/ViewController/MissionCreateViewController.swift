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
    
<<<<<<< Updated upstream
=======
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.style = .large
        indicator.backgroundColor = .black
        indicator.alpha = 0.5
        return indicator
    }()
    private let activityIndicatorImageView = UIImageView(imageName: "illustErrorPage")
    private let activityIndicatorDescriptionLabel: UILabel = {
        let label = UILabel(text: "미션 생성 요청 중...", letterSpacing: 0)
        label.textColor = .white
        label.font = UIFont(font: .systemBold, size: 24)
        return label
    }()
    
>>>>>>> Stashed changes
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(popToPreviousViewController), for: .touchUpInside)
        return button
    }()
    private let viewTitleLabel: UILabel = {
        let label = UILabel(text: "미션 등록", letterSpacing: -0.3)
        label.textColor = UIColor(red: 34, green: 34, blue: 34)
        label.font = UIFont(font: .systemSemiBold, size: 17)
        label.textAlignment = .center
        return label
    }()
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor(red: 246, green: 205, blue: 0), for: .normal)
        button.setTitleColor(UIColor(red: 204, green: 204, blue: 204), for: .disabled)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 17)
        button.addTarget(self, action: #selector(requestMissionCreate), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    private let bottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 229, green: 229, blue: 229).cgColor
        return view
    }()
    
    private let missionTitleDescriptionLabel: UILabel = {
        let label = UILabel(text: "소개", letterSpacing: -0.6)
        label.textColor = UIColor(red: 119, green: 119, blue: 119)
        label.font = UIFont(font: .systemBold, size: 15)
        return label
    }()
    private let missionDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor(red: 68, green: 68, blue: 68)
        textField.font = UIFont(font: .systemMedium, size: 17)
        textField.placeholder = "2~12자 이내로 입력해 주세요."
        textField.addTarget(self, action: #selector(limitTextFieldLength), for: .editingChanged)
        return textField
    }()
    private let textFieldBottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 229, green: 229, blue: 229).cgColor
        return view
    }()
    
    private let missionPhotoDescriptionLabel: UILabel = {
        let label = UILabel(text: "사진 업로드", letterSpacing: -0.6)
        label.textColor = UIColor(red: 119, green: 119, blue: 119)
        label.font = UIFont(font: .systemBold, size: 15)
        return label
    }()
    private let takeFromCameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconCamera"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 40, right: 0)
        button.setTitle("사진찍기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 15)
        button.titleEdgeInsets = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 23)
        button.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
        button.alpha = 0.3
        button.setRatioCornerRadius(18)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(takePhotoFromCamera), for: .touchUpInside)
        return button
    }()
    private let takeFromGalleryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconPhoto"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 60, bottom: 40, right: 0)
        button.setTitle("갤러리에서\n가져오기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(font: .systemBold, size: 15)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.titleEdgeInsets = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 25)
        button.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
        button.alpha = 0.3
        button.setRatioCornerRadius(18)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(takePhotoFromLibary), for: .touchUpInside)
        return button
    }()
    private let selectedPictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setRatioCornerRadius(18)
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    private let reloadPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconReload"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.setTitle("다시 올리기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(font: .systemSemiBold, size: 14)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(touchUpReloadButton), for: .touchUpInside)
        button.alpha = 0.3
        button.isHidden = true
        return button
    }()
    
    private let difficultyDescriptionLabel: UILabel = {
        let label = UILabel(text: "난이도 설정", letterSpacing: -0.6)
        label.textColor = UIColor(red: 119, green: 119, blue: 119)
        label.font = UIFont(font: .systemBold, size: 15)
        return label
    }()
    private let difficultyDescriptionDetailLabel: UILabel = {
        let label = UILabel(text: "설정값에 따라 벌금 액수가 달라집니다.", letterSpacing: -0.3)
        label.textColor = UIColor(red: 170, green: 170, blue: 170)
        label.font = UIFont(font: .systemMedium, size: 13)
        return label
    }()
    private let customSegmentedControl: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 242, green: 242, blue: 242).cgColor
        view.layer.cornerRadius = 18
        return view
    }()
    private var difficultyButtons = [UIButton]()
    private var selector: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255, green: 218, blue: 34)
        view.setRatioCornerRadius(18)
        view.layer.shadowColor = UIColor(red: 255, green: 212, blue: 104).cgColor
        view.layer.shadowOpacity = 0.56
        view.layer.shadowOffset = CGSize(width: 0, height: 7)
        view.layer.shadowRadius = 18
        view.isHidden = true
        return view
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        return dateFormatter
    }()
    
    private var imageName: String = ""
    private var difficulty: Int = 0
    
    private var isTitleSet: Bool = false
    private var isPictureSet: Bool = false
    private var isDifficulltySet: Bool = false
    
// MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        missionDescriptionTextField.delegate = self
        setLayout()
        setupCustomSegmentedControlView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK:- Navigation Control

extension MissionCreateViewController {
    
    @objc private func popToPreviousViewController(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK:- MissionCreate Request

extension MissionCreateViewController {
    
    @objc private func requestMissionCreate() {
        activityIndicator.startAnimating()
        let requestModel = MissionCreateModel()
        let requestSet = RequestSet(method: requestModel.method, path: requestModel.path)
        let beeId = UserDefaults.standard.integer(forKey: UserDefaultsKey.beeId.rawValue)
        guard let targetDate = UserDefaults.standard.object(forKey: UserDefaultsKey.targetDate.rawValue) as? Date,
              let description = missionDescriptionTextField.text,
              let image = selectedPictureView.image,
              let imageData = image.jpegData(compressionQuality: 0.5) else {
            activityIndicator.stopAnimating()
            presentConfirmAlert(title: "미션 생성 요청 에러!", message: "")
            return
        }
        let targetDateString = dateFormatter.string(from: targetDate)
        let parameter = ["beeId": "\(beeId)",
                         "description": description,
                         "type": "1",
                         "difficulty": "\(difficulty)",
                         "targetDate": targetDateString]
        KeychainService.extractKeyChainToken { [self] (accessToken, _, error) in
            if let error = error {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "토큰 에러!", message: error.localizedDescription)
                return
            }
            guard let accessToken = accessToken else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                presentConfirmAlert(title: "토큰 에러!", message: "")
                return
            }
            let header = [RequestHeader.accessToken.rawValue: accessToken]
<<<<<<< Updated upstream
            
            MultipartFormdataRequest().request(parameters: missionData,
                                               imageData: imageData,
                                               requestSet: requestSet,
                                               header: header) { (created, error) in
=======
            MultipartFormdataRequest().request(parameters: parameter,
                                               imageData: imageData,
                                               requestSet: requestSet,
                                               header: header) { (created, error) in
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
>>>>>>> Stashed changes
                if let error = error {
                    presentConfirmAlert(title: "미션 생성 요청 에러!", message: error.localizedDescription)
                    return
                }
                if created {
                    presentConfirmAlert(title: "미션 등록!", message: "성공적으로 등록하였습니다!") { _ in
                        NotificationCenter.default.post(name: Notification.Name.init("ReloadViewController"),
                                                        object: nil)
                        navigationController?.popViewController(animated: true)
                    }
                } else {
                    presentConfirmAlert(title: "미션 등록!", message: "등록에 실패하였습니다!" ) { _ in
                        NotificationCenter.default.post(name: Notification.Name.init("ReloadViewController"),
                                                        object: nil)
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

// MARK:- Complete Button Control

extension MissionCreateViewController {
    
    private func controlCompleteButton() {
        completeButton.isEnabled = isTitleSet && isPictureSet && isDifficulltySet
    }
}

// MARK:- TextField Handling

extension MissionCreateViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        missionDescriptionTextField.endEditing(true)
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        return true
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        isTitleSet = 1 < missionDescriptionTextField.text?.count ?? 0
        controlCompleteButton()
    }
    
    @objc private func limitTextFieldLength(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        if 12 < text.count {
            sender.text = String(text[..<text.index(text.startIndex, offsetBy: 12)])
        }
    }
}

// MARK:- Image Picker

extension MissionCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func hideImagePickerSection(_ state: Bool) {
        takeFromGalleryButton.isHidden = state
        takeFromCameraButton.isHidden = state
        selectedPictureView.isHidden = !state
        reloadPhotoButton.isHidden = !state
    }
    
    @objc private func takePhotoFromLibary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func takePhotoFromCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isPictureSet = false
        selectedPictureView.image = nil
        controlCompleteButton()
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        selectedPictureView.image = selectedImage
        isPictureSet = true
        controlCompleteButton()
        hideImagePickerSection(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func touchUpReloadButton(_ sender: UIButton) {
        hideImagePickerSection(false)
        selectedPictureView.image = nil
        isPictureSet = false
        controlCompleteButton()
    }
}

// MARK:- Segmented Control

extension MissionCreateViewController {
    
    private func setupSegmentControlButton(title: String) {
        let button = UIButton.init(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(UIColor(red: 204, green: 204, blue: 204), for: .normal)
        button.setTitleColor(UIColor(red: 68, green: 68, blue: 68), for: .selected)
        button.tintColor = .clear
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didTapSegmentedControl), for: .touchUpInside)
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
    
    @objc private func didTapSegmentedControl(_ sender: UIButton) {
        guard let difficultyIndex = difficultyButtons.firstIndex(of: sender) else {
            return
        }
        difficulty = 2 - difficultyIndex
        isDifficulltySet = true
        controlCompleteButton()
        for (buttonIndex, button) in difficultyButtons.enumerated() {
            button.isSelected = false
            if button == sender {
                button.isSelected = true
                let width = customSegmentedControl.frame.width
                let selectorStartPosition = width / CGFloat(difficultyButtons.count) * CGFloat(buttonIndex)
                if selector.isHidden {
                    selector.isHidden = false
                    self.selector.frame.origin.x = selectorStartPosition
                }
                UIView.animate(withDuration: 0.1, animations: {
                    self.selector.frame.origin.x = selectorStartPosition
                })
            }
        }
    }
}

// MARK:- Layout

extension MissionCreateViewController {
    
<<<<<<< Updated upstream
    private func setupDesign() {
=======
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
        activityIndicator.addSubview(activityIndicatorImageView)
        activityIndicatorImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(activityIndicator.snp.width)
            $0.width.equalToSuperview()
        }
        activityIndicatorImageView.addSubview(activityIndicatorDescriptionLabel)
        activityIndicatorDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(26 * DesignSet.frameHeightRatio)
        }
        
>>>>>>> Stashed changes
        view.addSubview(toPreviousButton)
        toPreviousButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
            $0.width.equalTo(12 * DesignSet.frameWidthRatio)
        }
        view.addSubview(viewTitleLabel)
        viewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
        }
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * DesignSet.frameHeightRatio)
            $0.trailing.equalTo(-24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
        }
        view.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(43 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
        }
        
        view.addSubview(missionTitleDescriptionLabel)
        missionTitleDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(71 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        view.addSubview(missionDescriptionTextField)
        missionDescriptionTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(107 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(20 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        view.addSubview(textFieldBottomlineView)
        textFieldBottomlineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(140 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        
        view.addSubview(missionPhotoDescriptionLabel)
        missionPhotoDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(195 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        view.addSubview(takeFromCameraButton)
        takeFromCameraButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(235 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(120 * DesignSet.frameHeightRatio)
            $0.width.equalTo(153 * DesignSet.frameWidthRatio)
        }
        view.addSubview(takeFromGalleryButton)
        takeFromGalleryButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(235 * DesignSet.frameHeightRatio)
            $0.trailing.equalTo(-24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(120 * DesignSet.frameHeightRatio)
            $0.width.equalTo(153 * DesignSet.frameWidthRatio)
        }
        view.addSubview(selectedPictureView)
        selectedPictureView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(235 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(120 * DesignSet.frameHeightRatio)
            $0.width.equalTo(153 * DesignSet.frameWidthRatio)
        }
        view.addSubview(reloadPhotoButton)
        reloadPhotoButton.snp.makeConstraints {
            $0.bottom.equalTo(selectedPictureView.snp.bottom)
            $0.leading.equalTo(selectedPictureView.snp.trailing).offset(15 * DesignSet.frameWidthRatio)
            $0.height.equalTo(18 * DesignSet.frameHeightRatio)
            $0.width.equalTo(100 * DesignSet.frameWidthRatio)
        }
        
        view.addSubview(difficultyDescriptionLabel)
        difficultyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(418 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(19 * DesignSet.frameHeightRatio)
        }
        view.addSubview(difficultyDescriptionDetailLabel)
        difficultyDescriptionDetailLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(443 * DesignSet.frameHeightRatio)
            $0.leading.equalTo(24 * DesignSet.frameWidthRatio)
            $0.height.equalTo(16 * DesignSet.frameHeightRatio)
        }
        view.addSubview(customSegmentedControl)
        customSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(477 * DesignSet.frameHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(96 * DesignSet.frameHeightRatio)
            $0.width.equalTo(327 * DesignSet.frameWidthRatio)
        }
        
<<<<<<< Updated upstream
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
=======
        activityIndicator.layer.zPosition = 1
>>>>>>> Stashed changes
    }
}
