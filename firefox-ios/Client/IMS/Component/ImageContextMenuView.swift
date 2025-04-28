// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import LTXiOSUtils

enum ImageContextMenuType: CaseIterable {
    case translate
    case unTranslate
    case save
    case copy
    case share
    case feedback
    
    var title: String {
        switch self {
        case .translate:
            return "Imt.imageContextMenu.translate".i18nImt()
        case .unTranslate:
            return "Imt.imageContextMenu.unTranslate".i18nImt()
        case .save:
            return "Imt.imageContextMenu.save".i18nImt()
        case .copy:
            return "Imt.imageContextMenu.copy".i18nImt()
        case .share:
            return "Imt.imageContextMenu.share".i18nImt()
        case .feedback:
            return "Imt.imageContextMenu.feedback".i18nImt()
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .translate:
            return UIImage(named: "toolbar_tranlate_normal")?.withRenderingMode(.alwaysTemplate)
        case .unTranslate:
            return UIImage(named: "toolbar_tranlate_active_all")?.withRenderingMode(.alwaysOriginal)
        case .save:
            return UIImage(named: "imageContextMenu_save")?.withRenderingMode(.alwaysTemplate)
        case .copy:
            return UIImage(named: "imageContextMenu_copy")?.withRenderingMode(.alwaysTemplate)
        case .share:
            return UIImage(named: "imageContextMenu_share")?.withRenderingMode(.alwaysTemplate)
        case .feedback:
            return UIImage(named: "imageContextMenu_feedback")?.withRenderingMode(.alwaysTemplate)
        }
    }
}

class ImageContextMenuViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(hexString: "333333").withDarkColor("D8D8D8")
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(hexString: "333333").withDarkColor("D8D8D8")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-16)
            make.height.width.equalTo(24)
        }
    }
    
    func setData(type: ImageContextMenuType) {
        titleLabel.text = type.title
        iconImageView.image = type.icon
    }
}

class ImageContextMenuView: UIView {
    var typeArr: [ImageContextMenuType] = []
    
    var selectCallback: ((ImageContextMenuType) -> Void)?
    
    private lazy var popupView: MaskPopupView = {
        let popupView = MaskPopupView(containerView: UIApplication.shared.keyWindow!, contentView: self, animator: MaskPopupViewFadeInOutAnimator())
        popupView.isDismissible = true
        popupView.backgroundView.style = .solidColor
        popupView.backgroundView.color = UIColor.black.withAlphaComponent(0.59)
        return popupView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 45
        tableView.isScrollEnabled = false
        tableView.register(ImageContextMenuViewCell.self, forCellReuseIdentifier: "ImageContextMenuViewCell")
        tableView.separatorStyle = .none
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .white.withDarkColor("111111")
        clipsToBounds = true
        layer.cornerRadius = 12

        addSubviews(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ImageContextMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageContextMenuViewCell") as! ImageContextMenuViewCell
        let model = typeArr[indexPath.row]
        cell.setData(type: model)
        return cell
    }
}

extension ImageContextMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = typeArr[indexPath.row]
        selectCallback?(model)
        hide()
    }
}

extension ImageContextMenuView {
    func show() {
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        let height = CGFloat(45 * typeArr.count)
        frame = CGRect(x: (screenWidth - 202) / 2, y: (screenHeight - height) / 2, width: 202, height: height)
        tableView.reloadData()
        popupView.display(animated: true, completion: nil)
    }

    @objc
    private func hide() {
        popupView.dismiss(animated: false, completion: nil)
    }
}
