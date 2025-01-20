// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


import UIKit

class ProYearSubscriptionViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "年费Pro会员"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let proLabel: UILabel = {
        let label = UILabel()
        label.text = "Pro"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.backgroundColor = .black
        label.textColor = .white
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "¥48.3/月"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let yearlyPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "¥579.6/年"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let savingsLabel: UILabel = {
        let label = UILabel()
        label.text = "立省248.4元"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let featuresStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let subscribeButton: UIButton = {
        let button = UIButton()
        button.setTitle("立即订阅", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(closeButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(proLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(yearlyPriceLabel)
        containerView.addSubview(savingsLabel)
        containerView.addSubview(featuresStackView)
        containerView.addSubview(subscribeButton)
        
        setupConstraints()
        setupFeatures()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            proLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            proLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            yearlyPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            yearlyPriceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            savingsLabel.centerYAnchor.constraint(equalTo: yearlyPriceLabel.centerYAnchor),
            savingsLabel.leadingAnchor.constraint(equalTo: yearlyPriceLabel.trailingAnchor, constant: 16),
            
            featuresStackView.topAnchor.constraint(equalTo: yearlyPriceLabel.bottomAnchor, constant: 32),
            featuresStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            featuresStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            subscribeButton.topAnchor.constraint(equalTo: featuresStackView.bottomAnchor, constant: 32),
            subscribeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            subscribeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            subscribeButton.heightAnchor.constraint(equalToConstant: 50),
            subscribeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32)
        ])
    }
    
    private func setupFeatures() {
        let features = [
            ("Pro专属全球顶尖AI翻译服务", [
                "DeepL 翻译",
                "OpenAI 翻译",
                "Claude 翻译",
                "Gemini 翻译"
            ]),
            ("Pro专属高级功能", [
                "PDF Pro",
                "漫画翻译",
                "Youtube 双语字幕下载",
                "多设备同步配置",
                "优先的电子邮件支持"
            ])
        ]
        
        for (title, items) in features {
            let sectionLabel = UILabel()
            sectionLabel.text = title
            sectionLabel.font = .systemFont(ofSize: 16, weight: .medium)
            featuresStackView.addArrangedSubview(sectionLabel)
            
            for item in items {
                let itemView = createFeatureItemView(text: item)
                featuresStackView.addArrangedSubview(itemView)
            }
        }
    }
    
    private func createFeatureItemView(text: String) -> UIView {
        let container = UIView()
        
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark"))
        checkmark.tintColor = .systemGreen
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(checkmark)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            checkmark.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            checkmark.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 20),
            checkmark.heightAnchor.constraint(equalToConstant: 20),
            
            label.leadingAnchor.constraint(equalTo: checkmark.trailingAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        return container
    }
    
    @objc
    func closeAction() {
        self.dismiss(animated: true)
    }
}
