// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


import UIKit

class ProMonthSubscriptionViewController: UIViewController {
    
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
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "月费Pro会员"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let proLabel: UILabel = {
        let label = UILabel()
        label.text = "Pro"
        label.font = .systemFont(ofSize: 14)
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "¥69/月"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .systemPink
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let aiServicesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Pro专属全球顶尖AI翻译服务"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let advancedFeaturesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Pro专属高级功能"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subscribeButton: UIButton = {
        let button = UIButton()
        button.setTitle("立即订阅", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var aiServicesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let services = ["DeepL 翻译", "OpenAI 翻译", "Claude 翻译", "Gemini 翻译"]
        services.forEach { service in
            stack.addArrangedSubview(createFeatureRow(text: service))
        }
        
        return stack
    }()
    
    private lazy var advancedFeaturesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let features = ["PDF Pro", "漫画翻译", "Youtube 双语字幕下载", "多设备同步配置", "优先的电子邮件支持"]
        features.forEach { feature in
            stack.addArrangedSubview(createFeatureRow(text: feature))
        }
        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        [closeButton, titleLabel, proLabel, priceLabel, 
         aiServicesTitleLabel, aiServicesStackView,
         advancedFeaturesTitleLabel, advancedFeaturesStackView,
         subscribeButton].forEach { containerView.addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContainerView
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Close Button
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            // Pro Label
            proLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            proLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            proLabel.widthAnchor.constraint(equalToConstant: 40),
            proLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // Price Label
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // AI Services Title
            aiServicesTitleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 30),
            aiServicesTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            // AI Services Stack
            aiServicesStackView.topAnchor.constraint(equalTo: aiServicesTitleLabel.bottomAnchor, constant: 15),
            aiServicesStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            aiServicesStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Advanced Features Title
            advancedFeaturesTitleLabel.topAnchor.constraint(equalTo: aiServicesStackView.bottomAnchor, constant: 30),
            advancedFeaturesTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            // Advanced Features Stack
            advancedFeaturesStackView.topAnchor.constraint(equalTo: advancedFeaturesTitleLabel.bottomAnchor, constant: 15),
            advancedFeaturesStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            advancedFeaturesStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Subscribe Button
            subscribeButton.topAnchor.constraint(equalTo: advancedFeaturesStackView.bottomAnchor, constant: 30),
            subscribeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            subscribeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            subscribeButton.heightAnchor.constraint(equalToConstant: 50),
            subscribeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
    }
    
    private func createFeatureRow(text: String) -> UIView {
        let container = UIView()
        
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark"))
        checkmark.tintColor = .systemGreen
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(checkmark)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            checkmark.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            checkmark.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 20),
            checkmark.heightAnchor.constraint(equalToConstant: 20),
            
            label.leadingAnchor.constraint(equalTo: checkmark.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        return container
    }
}
