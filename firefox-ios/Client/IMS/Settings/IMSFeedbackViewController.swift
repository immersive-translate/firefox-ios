// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Shared
import LTXiOSUtils
import Photos
import PhotosUI

enum FeedType: CaseIterable {
    case bug
    case feat
    
    var title: String {
        switch self {
        case .bug:
            return "Imt.Setting.feedback.type.bug".i18nImt()
        case .feat:
            return "Imt.Setting.feedback.type.feat".i18nImt()
        }
    }
    
    var type: String {
        switch self {
        case .bug:
            return "appBug"
        case .feat:
            return "appFeedBack"
        }
    }
}

class IMSFeedbackViewController: UIViewController {
    var windowUUID: WindowUUID?
    
    private var arr: [FeedType] = FeedType.allCases
    
    private var type: FeedType = .bug {
        didSet {
            reloadTypeView()
        }
    }
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Imt.Setting.feedback.submit".i18nImt(), for: .normal)
        button.layer.cornerRadius = 12.0
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(submitButtonOnClick), for: .touchUpInside)
        button.backgroundColor = UIColor(colorString: "222222")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private lazy var typeView: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: FeedType.allCases.compactMap({ $0.title }))
        segmentedControl.tintColor = UIColor(colorString: "#E6E6E6").withAlphaComponent(0.5)
        segmentedControl.selectedSegmentTintColor = .white.withDarkColor("191919")
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hexString: "#666666").withDarkColor("B3B3B3"),
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(colorString: "222222").withDarkColor("DBDBDB"),
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(colorString: "222222").withDarkColor("DBDBDB")
        label.text = "Imt.Setting.feedback.desc".i18nImt()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bugLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hexString: "#666666").withDarkColor("B3B3B3")
        return label
    }()
    
    private lazy var bugTextView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 12.0
        view.clipsToBounds = true
        view.backgroundColor = UIColor(hexString: "#FAFBFC").withDarkColor("2B2D30")
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexString: "#ECF0F7").withDarkColor("3E434B").cgColor
        view.placeholdFont = UIFont.systemFont(ofSize: 14)
        view.placeholdColor = UIColor(hexString: "#CCCCCC").withDarkColor("5C5C5C")
        view.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return view
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hexString: "#666666").withDarkColor("B3B3B3")
        label.text = "Imt.Setting.feedback.email.title".i18nImt()
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 12.0
        view.clipsToBounds = true
        view.backgroundColor = UIColor(hexString: "#FAFBFC").withDarkColor("2B2D30")
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexString: "#ECF0F7").withDarkColor("3E434B").cgColor
        view.attributedPlaceholder = NSAttributedString(
            string: "Imt.Setting.feedback.email.placeholder".i18nImt(),
            attributes: [
                .foregroundColor: UIColor(hexString: "#CCCCCC").withDarkColor("5C5C5C"),
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        view.textColor = UIColor(colorString: "222222").withDarkColor("DBDBDB")
        view.font = UIFont.systemFont(ofSize: 14)
        view.leftViewMode = .always
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        return view
    }()
    
    private lazy var imageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hexString: "#666666").withDarkColor("B3B3B3")
        label.text = "Imt.Setting.feedback.image.title".i18nImt()
        return label
    }()
    
    private lazy var pickImageView: IMSImagePickGridView = {
        let imageView = IMSImagePickGridView()
        imageView.delegte = self
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let themeManager: ThemeManager = AppContainer.shared.resolve()
        view.backgroundColor = themeManager.getCurrentTheme(for: windowUUID).colors.layer2
        title = "Imt.Setting.menu.feedback".i18nImt()
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        setupUI()
        type = .bug
        emailTextField.text = IMSAccountManager.shard.current()?.email
    }
    
    private func setupUI() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let baseView = UIView()
        scrollView.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(min(view.frame.width, 580))
        }
        
        
        baseView.addSubview(typeView)
        typeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(36)
            make.width.equalTo(335)
        }
        
        baseView.addSubview(contentLabel)
        baseView.addSubview(bugTextView)
        baseView.addSubview(bugLabel)
        baseView.addSubview(emailLabel)
        baseView.addSubview(imageLabel)
        baseView.addSubview(emailTextField)
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(typeView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        let asteriskLabel = UILabel()
        asteriskLabel.text = "*"
        asteriskLabel.font = UIFont.systemFont(ofSize: 14)
        asteriskLabel.textColor = UIColor(hexString: "#FF5B5B")
        baseView.addSubview(asteriskLabel)
        asteriskLabel.snp.makeConstraints { make in
            make.left.equalTo(contentLabel)
            make.top.equalTo(bugLabel.snp.top)
        }
        bugLabel.snp.makeConstraints { make in
            make.left.equalTo(asteriskLabel.snp.right)
            make.top.equalTo(contentLabel.snp.bottom).offset(24)
            make.height.equalTo(21)
        }
        
        bugTextView.snp.makeConstraints { make in
            make.top.equalTo(bugLabel.snp.bottom).offset(8)
            make.left.right.equalTo(contentLabel)
            make.height.equalTo(140)
        }
        
        imageLabel.snp.makeConstraints { make in
            make.left.equalTo(contentLabel)
            make.height.equalTo(21)
            make.top.equalTo(bugTextView.snp.bottom).offset(20)
        }
        
        baseView.addSubview(pickImageView)
        pickImageView.snp.makeConstraints { make in
            make.top.equalTo(imageLabel.snp.bottom).offset(8)
            make.left.right.equalTo(contentLabel)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(contentLabel)
            make.height.equalTo(21)
            make.top.equalTo(pickImageView.snp.bottom).offset(20)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.left.right.equalTo(contentLabel)
            make.height.equalTo(44)
        }
        
        baseView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(335)
            make.centerX.equalToSuperview()
        }
    }
    
    private func reloadTypeView() {
        bugTextView.subviews.forEach {
            if let label = $0 as? UILabel {
                label.removeFromSuperview()
            }
        }
        switch type {
        case .bug:
            bugLabel.text = "Imt.Setting.feedback.bug.title".i18nImt()
            bugTextView.placeholder = "Imt.Setting.feedback.bug.placeholder".i18nImt()
        case .feat:
            bugLabel.text = "Imt.Setting.feedback.feat.title".i18nImt()
            bugTextView.placeholder = "Imt.Setting.feedback.feat.placeholder".i18nImt()
        }
    }
    
    @objc
    private func submitButtonOnClick() {
        guard let reason = bugTextView.text, reason.isNotEmpty else {
            SVProgressHUD.toast(bugTextView.placeholder)
            return
        }
        let request = FeedbackAPI.WebReportLogRequest(reason: reason, feedType: type, imageArr: pickImageView.imageList.compactMap({ $0.data }), contactInfo: emailTextField.text)
        SVProgressHUD.show()
        APIService.sendFormDataRequest(request) { response in
            SVProgressHUD.dismiss()
            switch response.result.validateResult {
            case .success:
                SVProgressHUD.success("Imt.Setting.feedback.submit.success".i18nImt())
                self.navigationController?.dismiss(animated: true)
            case .failure:
                SVProgressHUD.error("Imt.Setting.feedback.submit.error".i18nImt())
            }
        }
    }
    
    @objc
    private func segmentChanged(_ sender: UISegmentedControl) {
        type = arr[sender.selectedSegmentIndex]
    }
    
    private func uploadImage(image: UIImage, name: String, id: String) {
        let compressData = image.tx.compressOriginalImage(toBytes: 800 * 1024)
        guard let data = compressData != nil ? compressData : image.jpegData(compressionQuality: 0.5) else {
            return
        }
        let fileInfo = IMSAPIFile(data: data, name: name)
        let request = FeedbackAPI.ImgUploadRequest(fileInfo: fileInfo)
        APIService.sendFormDataRequest(request) { response in
            switch response.result.validateResult {
            case let .success(info):
                if let model = self.pickImageView.imageList.filter({ $0.id == id }).first {
                    model.state = .success
                    model.data = info
                    self.pickImageView.updateImage(model: model)
                    self.reloadSubmitButton()
                }
            case .failure:
                if let model = self.pickImageView.imageList.filter({ $0.id == id }).first {
                    model.state = .fail
                    self.pickImageView.updateImage(model: model)
                    self.reloadSubmitButton()
                }
                SVProgressHUD.error("Imt.Setting.feedback.image.submit.error".i18nImt())
            }
        }
    }
    
    private func reloadSubmitButton() {
        if !pickImageView.imageList.contains(where: { $0.state != .success }) {
            submitButton.backgroundColor = UIColor(colorString: "222222")
            submitButton.isEnabled = true
        } else {
            submitButton.backgroundColor = UIColor(colorString: "C7C7C7")
            submitButton.isEnabled = false
        }
    }
}

extension IMSFeedbackViewController: IMSImagePickGridViewDelegte {
    func addImage(imagePickGridView: IMSImagePickGridView) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = pickImageView.canPickResidueMaxCount
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func clickImage(imagePickGridView: IMSImagePickGridView, index: Int) {
        let model = pickImageView.imageList[index]
        if model.state == .fail {
            model.state = .ing
            self.pickImageView.updateImage(model: model)
            DispatchQueue.global().async {
                self.uploadImage(image: model.image, name: model.name, id: model.id)
            }
            reloadSubmitButton()
        }
    }
}

extension IMSFeedbackViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                guard let self = self else { return }
                if let image = object as? UIImage {
                    let id = "\(Date().timeIntervalSince1970)".replacingOccurrences(of: ".", with: "")
                    let name = id + ".jpg"
                    DispatchQueue.main.async {
                        self.pickImageView.addImage(imageArr: [PickImageModel(image: image, id: id, name: name, state: .ing, data: nil)])
                        self.reloadSubmitButton()
                    }
                    DispatchQueue.global().async {
                        self.uploadImage(image: image, name: name, id: id)
                    }
                }
            }
        }
    }
}
