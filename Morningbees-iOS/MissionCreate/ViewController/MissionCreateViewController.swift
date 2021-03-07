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
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.style = .large
        indicator.backgroundColor = .black
        indicator.alpha = 0.5
        return indicator
    }()
    
    private let toPreviousButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
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
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(limitTextFieldLength), for: .editingChanged)
        return textField
    }()
    private let textFieldBottomlineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 229, green: 229, blue: 229).cgColor
        return view
    }()
    private let unavailableNameDescriptionLabel: UILabel = {
        let label = UILabel(text: "", letterSpacing: -0.4)
        label.textColor = UIColor(red: 235, green: 54, blue: 54)
        label.font = UIFont(font: .systemMedium, size: 13)
        label.alpha = 0
        return label
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NavigationControl.navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK:- Navigation Control

extension MissionCreateViewController {
    
    @objc private func popToPreviousViewController(_ sender: UIButton) {
        NavigationControl.popViewController()
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
                presentConfirmAlert(title: "토큰 에러!", message: error.description)
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
            MultipartFormdataRequest().request(parameters: parameter,
                                               imageData: imageData,
                                               requestSet: requestSet,
                                               header: header) { (isCreated, error) in
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                if let error = error {
                    presentConfirmAlert(title: "미션 생성 요청 에러!", message: error.description)
                    return
                }
                if isCreated {
                    presentConfirmAlert(title: "미션 등록!", message: "성공적으로 등록하였습니다!") { _ in
                        NotificationCenter.default.post(name: Notification.Name.init("ReloadViewController"),
                                                        object: nil)
                        NavigationControl.popViewController()
                    }
                } else {
                    presentConfirmAlert(title: "미션 등록!", message: "등록에 실패하였습니다!" ) { _ in
                        NotificationCenter.default.post(name: Notification.Name.init("ReloadViewController"),
                                                        object: nil)
                        NavigationControl.popViewController()
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
    
    @objc private func limitTextFieldLength(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        if text.count == 0 {
            isTitleSet = false
            textFieldBottomlineView.layer.borderColor = UIColor(red: 221, green: 221, blue: 221).cgColor
            UIView.animate(withDuration: 0.1) { [self] in
                unavailableNameDescriptionLabel.alpha = 0
            }
        } else if text.count < 2 {
            isTitleSet = false
            textFieldBottomlineView.layer.borderColor = UIColor(red: 235, green: 54, blue: 54).cgColor
            unavailableNameDescriptionLabel.text = "X 글자 수가 너무 짧아요."
            UIView.animate(withDuration: 0.5) { [self] in
                unavailableNameDescriptionLabel.alpha = 1
            }
            shakeLabel()
        } else if !inspectTextRegulation(originText: text) {
            isTitleSet = false
            unavailableNameDescriptionLabel.text = "X 포함될 수 없는 문자가 있어요."
            UIView.animate(withDuration: 0.5) { [self] in
                unavailableNameDescriptionLabel.alpha = 1
            }
            shakeLabel()
        } else {
            isTitleSet = true
            textFieldBottomlineView.layer.borderColor = UIColor(red: 34, green: 34, blue: 34).cgColor
            UIView.animate(withDuration: 0.1) { [self] in
                unavailableNameDescriptionLabel.alpha = 0
            }
        }
        if 12 < text.count {
            sender.text = String(text[..<text.index(text.startIndex, offsetBy: 12)])
        }
        controlCompleteButton()
    }
    
    private func inspectTextRegulation(originText: String) -> Bool {
        let filter: String = "[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ~!_@#$%^&*()+=.,:;?<>/` ]"
        let regulation = try? NSRegularExpression(pattern: filter, options: [])
        let newText = regulation?.matches(in: originText,
                                          options: [],
                                          range: NSRange.init(location: 0, length: originText.count))
        if newText?.count != originText.count {
            return false
        }
        return true
    }
    
    private func shakeLabel() {
        UIView.animate(withDuration: 0.05, delay: 0, options: [.repeat, .autoreverse]) { [self] in
            UIView.modifyAnimations(withRepeatCount: 2, autoreverses: true) {
                unavailableNameDescriptionLabel.transform = CGAffineTransform(translationX: +10, y: 0)
                unavailableNameDescriptionLabel.transform = .identity
            }
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
        selector.frame.size = CGSize(width: 109 * ToolSet.widthRatio, height: 96 * ToolSet.heightRatio)
        let stackView = UIStackView.init(arrangedSubviews: difficultyButtons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        customSegmentedControl.addSubview(stackView)
        stackView.frame.size = CGSize(width: 327 * ToolSet.widthRatio, height: 96 * ToolSet.heightRatio)
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
                UIView.animate(withDuration: 0.3, animations: {
                    self.selector.frame.origin.x = selectorStartPosition
                })
            }
        }
    }
}

// MARK:- Layout

extension MissionCreateViewController {
    
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.height.width.equalToSuperview()
        }
        
        view.addSubview(toPreviousButton)
        toPreviousButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11 * ToolSet.heightRatio)
            $0.leading.equalTo(12 * ToolSet.widthRatio)
            $0.height.equalTo(20 * ToolSet.heightRatio)
            $0.width.equalTo(30 * ToolSet.heightRatio)
        }
        view.addSubview(viewTitleLabel)
        viewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20 * ToolSet.heightRatio)
        }
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12 * ToolSet.heightRatio)
            $0.trailing.equalTo(-24 * ToolSet.widthRatio)
            $0.height.equalTo(20 * ToolSet.heightRatio)
        }
        view.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(43 * ToolSet.heightRatio)
            $0.centerX.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        view.addSubview(missionTitleDescriptionLabel)
        missionTitleDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(71 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(19 * ToolSet.heightRatio)
        }
        view.addSubview(missionDescriptionTextField)
        missionDescriptionTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(107 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(20 * ToolSet.heightRatio)
            $0.width.equalTo(327 * ToolSet.widthRatio)
        }
        view.addSubview(textFieldBottomlineView)
        textFieldBottomlineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(140 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
            $0.width.equalTo(327 * ToolSet.widthRatio)
        }
        view.addSubview(unavailableNameDescriptionLabel)
        unavailableNameDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(textFieldBottomlineView.snp.top).offset(12 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(16 * ToolSet.heightRatio)
        }
        
        view.addSubview(missionPhotoDescriptionLabel)
        missionPhotoDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(195 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(19 * ToolSet.heightRatio)
        }
        view.addSubview(takeFromCameraButton)
        takeFromCameraButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(235 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(120 * ToolSet.heightRatio)
            $0.width.equalTo(153 * ToolSet.widthRatio)
        }
        view.addSubview(takeFromGalleryButton)
        takeFromGalleryButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(235 * ToolSet.heightRatio)
            $0.trailing.equalTo(-24 * ToolSet.widthRatio)
            $0.height.equalTo(120 * ToolSet.heightRatio)
            $0.width.equalTo(153 * ToolSet.widthRatio)
        }
        view.addSubview(selectedPictureView)
        selectedPictureView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(235 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(120 * ToolSet.heightRatio)
            $0.width.equalTo(153 * ToolSet.widthRatio)
        }
        view.addSubview(reloadPhotoButton)
        reloadPhotoButton.snp.makeConstraints {
            $0.bottom.equalTo(selectedPictureView.snp.bottom)
            $0.leading.equalTo(selectedPictureView.snp.trailing).offset(15 * ToolSet.widthRatio)
            $0.height.equalTo(18 * ToolSet.heightRatio)
            $0.width.equalTo(100 * ToolSet.widthRatio)
        }
        
        view.addSubview(difficultyDescriptionLabel)
        difficultyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(418 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(19 * ToolSet.heightRatio)
        }
        view.addSubview(difficultyDescriptionDetailLabel)
        difficultyDescriptionDetailLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(443 * ToolSet.heightRatio)
            $0.leading.equalTo(24 * ToolSet.widthRatio)
            $0.height.equalTo(16 * ToolSet.heightRatio)
        }
        view.addSubview(customSegmentedControl)
        customSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(477 * ToolSet.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(96 * ToolSet.heightRatio)
            $0.width.equalTo(327 * ToolSet.widthRatio)
        }
        
        activityIndicator.layer.zPosition = 1
    }
}
