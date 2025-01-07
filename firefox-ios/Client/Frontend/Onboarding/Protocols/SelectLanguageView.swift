// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit
import Common
import ComponentLibrary
import Shared

class SelectLanguageCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont .systemFont(ofSize: 14)
        titleLabel.textColor =  UIColor(colorString: "222222")
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear;
        self.contentView.backgroundColor = UIColor(colorString: "FAFBFC")
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateTitle(title: String) {
        titleLabel.text = title
    }
    
    func initUI() {
        self.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
    }
}

class SelectLanguageView: UIView,  UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    init() {
       super.init(frame: CGRectZero);
        setupViews();
        initData();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var dataArray: [Dictionary<String, String>] = []
    private var allDataArray: [Dictionary<String, String>] = []

    private var isShowAll: Bool = false

    private var selectItem: Dictionary<String, String>?
    
    private lazy var selectTextField: UITextField = {
        let selectTextField = UITextField()
        selectTextField.translatesAutoresizingMaskIntoConstraints = false
        selectTextField.font = UIFont .systemFont(ofSize: 14)
        selectTextField.textColor =  UIColor(colorString: "222222")
        selectTextField.delegate = self
        selectTextField.returnKeyType = .done
        selectTextField.addTarget(self, action:  #selector(editingChanged), for: .editingChanged)
        selectTextField.addTarget(self, action: #selector(endEdit), for: .editingDidEndOnExit)
        return selectTextField
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(named: "down-arrow");
        return arrowImageView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(SelectLanguageCell.self, forCellReuseIdentifier: "SelectLanguageCell")
        return tableView
    }()
    
    func setupViews() {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelMutableAttribute = NSMutableAttributedString(string: "*",
                                                              attributes: [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 14),
                                                                           NSAttributedString.Key.foregroundColor:  UIColor(colorString: "FF5B5B")])
        let text:String = .ImtLocalizableIntroNativeLanguage
        labelMutableAttribute.append(NSAttributedString(string: "\(text)：", attributes: [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 14),
                                                                                      NSAttributedString.Key.foregroundColor:  UIColor(colorString: "666666")]))
        label.attributedText = labelMutableAttribute
        addSubviews(label)
        
        let selectView = UIView();
        selectView.translatesAutoresizingMaskIntoConstraints = false
        selectView.backgroundColor = UIColor(colorString: "FAFBFC")
        selectView.layer.borderColor = UIColor(colorString: "ECF0F7").cgColor
        selectView.layer.borderWidth = 1.0
        selectView.layer.cornerRadius = 12.0
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showAll))
        selectView.isUserInteractionEnabled = true;
        selectView.addGestureRecognizer(tapRecognizer)
        selectView.addSubview(selectTextField)
        selectView.addSubview(arrowImageView)
        addSubviews(selectView)
        
        addSubviews(tableView)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor),
            selectView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            selectView.leftAnchor.constraint(equalTo: label.leftAnchor),
            selectView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            selectView.heightAnchor.constraint(equalToConstant: 44),
            tableView.topAnchor.constraint(equalTo: selectView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: label.leftAnchor),
            tableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                        
            selectTextField.leftAnchor.constraint(equalTo: selectView.leftAnchor, constant: 20),
            selectTextField.centerYAnchor.constraint(equalTo: selectView.centerYAnchor),
            selectTextField.topAnchor.constraint(equalTo: selectView.topAnchor),
            selectTextField.rightAnchor.constraint(equalTo: arrowImageView.leftAnchor, constant: -20),
            arrowImageView.centerYAnchor.constraint(equalTo: selectView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16.0),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16.0),
            arrowImageView.rightAnchor.constraint(equalTo: selectView.rightAnchor, constant: -20)
        ])
    }
    
    func initData() {
        var jsonName = "en"
        if let preferredLocalizations = NSLocale.preferredLanguages.first {
            if (preferredLocalizations.contains("zh-Hans")) {
                jsonName = "zh-CN"
            } else if (preferredLocalizations.contains("zh-Hant")) {
                jsonName = "zh-TW"
            }
        }
        if let text = try? NSString(
            contentsOfFile:  Bundle.main.path(
                forResource: jsonName, ofType: "json") ?? "",
            encoding: String.Encoding.utf8.rawValue) as String {
            do {
                let data = text.data(using: String.Encoding.utf8)!
                allDataArray = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as! [Dictionary<String, String>]
                dataArray = allDataArray
                
                allDataArray.forEach { item in
                    if item["code"] == jsonName  {
                        updateSelectItem(item: item)
                    }
                }
            } catch {
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowAll ? dataArray.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLanguageCell", for: indexPath) as! SelectLanguageCell
        let item = dataArray[indexPath.row]
        cell.updateTitle(title: item["language"] ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataArray[indexPath.row]
        updateSelectItem(item: item)
    }
    
    
    @objc func editingChanged() {
        updateDataArray()
    }
    
    @objc func endEdit() {
        isShowAll = false;
        tableView.reloadData()
        updateTextField()
    }

    @objc func showAll() {
        isShowAll = !isShowAll
        tableView.reloadData()
        updateTextField()
        if isShowAll {
            updateDataArray()
        }
    }
    
    func updateSelectItem(item: Dictionary<String, String>) {
        selectItem = item
        let value = item.asString;
        UserDefaults.standard.setValue(value, forKey: BusinessJSObject.SelectLanguageKey);
        UserDefaults.standard.synchronize();
        isShowAll = false
        tableView.reloadData()
        updateTextField()
    }
    
    func updateDataArray() {
        var array: [Dictionary<String, String>] = []
        if let text = selectTextField.text, !text.isEmpty {
            allDataArray.forEach { item in
                if let language = item["language"], language.contains(text) {
                    array.append(item)
                }
            }
            dataArray = array;
        } else {
            dataArray = allDataArray;
        }
        tableView.reloadData()
    }
    
    func updateTextField() -> Void {
        if let language = selectItem?["language"] {
            if isShowAll {
                selectTextField.isUserInteractionEnabled = true
                selectTextField.becomeFirstResponder()
                let normalAttributes = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 14),
                                        NSAttributedString.Key.foregroundColor: UIColor(colorString: "999999")]
                selectTextField.text = nil;
                selectTextField.attributedPlaceholder = NSAttributedString(string: language, attributes: normalAttributes)
            } else {
                selectTextField.resignFirstResponder()
                selectTextField.isUserInteractionEnabled = false
                selectTextField.text = language;
                selectTextField.attributedPlaceholder = nil
            }
        } else {
            selectTextField.text = nil;
            selectTextField.attributedPlaceholder = nil
        }
    }
}
