// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


import UIKit

class ProMembershipViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "恭喜您成功升级为Pro会员"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let translationServicesView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    // 创建翻译服务选项
    private func createTranslationButtons() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        
        let services = ["DeepL翻译", "OpenAI翻译", "Gemini翻译", "Claude翻译"]
        
        for service in services {
            let button = UIButton()
            button.setTitle(service, for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 8
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            stack.addArrangedSubview(button)
        }
        
        return stack
    }
    
    // 创建功能项
    private func createFeatureItem(icon: String, title: String, description: String) -> UIView {
        let container = UIView()
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        
        let iconImage = UIImageView()
        iconImage.image = UIImage(systemName: icon)
        iconImage.tintColor = .systemBlue
        iconImage.contentMode = .scaleAspectFit
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 4
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.textColor = .systemGray
        descLabel.numberOfLines = 0
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descLabel)
        
        stack.addArrangedSubview(iconImage)
        stack.addArrangedSubview(textStack)
        
        container.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
        
        return container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(mainStackView)
        
        // 添加所有视图元素
        mainStackView.addArrangedSubview(headerLabel)
        mainStackView.addArrangedSubview(translationServicesView)
        
        // 添加功能项
        let features = [
            ("doc.text.magnifyingglass", "双语网页阅读", "你可以在任意网站调用翻译服务进行网页翻译"),
            ("doc.text", "PDF Pro", "AI驱动的PDF翻译"),
            ("book", "漫画翻译", "支持多家主流漫画网站"),
            ("video", "Youtube 双语字幕下载", "支持多家主流视频网站的字幕翻译"),
            ("icloud", "多设备同步配置", "可在多个设备同步使用"),
            ("envelope", "优先的电子邮件支持", "专属邮件支持服务")
        ]
        
        for feature in features {
            mainStackView.addArrangedSubview(createFeatureItem(icon: feature.0, title: feature.1, description: feature.2))
        }
        
        // 设置约束
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
}
