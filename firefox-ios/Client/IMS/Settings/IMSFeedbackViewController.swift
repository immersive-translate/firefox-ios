// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Shared
import LTXiOSUtils
import ZLPhotoBrowser

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
        view.addSubview(typeView)
        typeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.height.equalTo(36)
            make.width.equalTo(335)
        }
        
        view.addSubview(contentLabel)
        view.addSubview(bugTextView)
        view.addSubview(bugLabel)
        view.addSubview(emailLabel)
        view.addSubview(imageLabel)
        view.addSubview(emailTextField)
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(typeView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        let asteriskLabel = UILabel()
        asteriskLabel.text = "*"
        asteriskLabel.font = UIFont.systemFont(ofSize: 14)
        asteriskLabel.textColor = UIColor(hexString: "#FF5B5B")
        view.addSubview(asteriskLabel)
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
        
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(contentLabel)
            make.height.equalTo(21)
            make.top.equalTo(bugTextView.snp.bottom).offset(20)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.left.right.equalTo(contentLabel)
            make.height.equalTo(44)
        }
        imageLabel.snp.makeConstraints { make in
            make.left.equalTo(contentLabel)
            make.height.equalTo(21)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-45)
            make.height.equalTo(50)
            make.width.equalTo(335)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(pickImageView)
        pickImageView.snp.makeConstraints { make in
            make.top.equalTo(imageLabel.snp.bottom).offset(8)
            make.left.right.equalTo(contentLabel)
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
            case .success(_):
                SVProgressHUD.success("Imt.Setting.feedback.submit.success".i18nImt())
                self.navigationController?.dismiss(animated: true)
            case .failure:
                SVProgressHUD.error("Imt.CommonI.Error.Message".i18nImt())
            }
        }
    }
    
    @objc
    private func segmentChanged(_ sender: UISegmentedControl) {
        type = arr[sender.selectedSegmentIndex]
    }
    
    private func uploadImage(fileInfo: IMSAPIFile) {
        let request = FeedbackAPI.ImgUploadRequest(fileInfo: fileInfo)
        SVProgressHUD.show()
        APIService.sendFormDataRequest(request) { response in
            SVProgressHUD.dismiss()
            switch response.result.validateResult {
            case let .success(info):
                self.pickImageView.addImage(imageArr: [PickImageModel(image: UIImage(data: fileInfo.data), id: nil, data: info)])
            case .failure:
                SVProgressHUD.error("Imt.CommonI.Error.Message".i18nImt())
            }
        }
    }
}

extension IMSFeedbackViewController: IMSImagePickGridViewDelegte {
    func addImage(IMSImagePickGridView: IMSImagePickGridView) {
        ZLPhotoConfiguration.default()
            .maxSelectCount(1)
            .allowSelectVideo(false)
            .allowSelectOriginal(false)
            .saveNewImageAfterEdit(false)

        let ps = ZLPhotoPreviewSheet()
        ps.selectImageBlock = { [weak self] results, _ in
            guard let self = self else { return }
            if let image = results.first?.image {
                let compressData = image.tx.compressOriginalImage(toBytes: 50 * 1024)
                let data = compressData != nil ? compressData : image.jpegData(compressionQuality: 0.5)
                if data == nil {
                    return
                }
                self.uploadImage(fileInfo: IMSAPIFile(data: data!, name: "\(Int(Date().timeIntervalSince1970)).JPG"))
            } else {
                SVProgressHUD.error("Imt.CommonI.Error.Message".i18nImt())
            }
        }
        if let viewController = UIViewController.tx.topViewController() {
            ps.showPhotoLibrary(sender: viewController)
        }
    }
}
