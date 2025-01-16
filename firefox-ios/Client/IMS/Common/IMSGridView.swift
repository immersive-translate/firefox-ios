// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import UIKit


struct IMSGridItem {
    let icon: String
    let title: String
}

struct IMSGridConfig {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    let imageSize: CGSize
    let titleFont: UIFont
}

class IMSGridView: UIView {
    // MARK: - Properties
    private let columns: Int
    private let config: IMSGridConfig
    private var mainStackView: UIStackView!
    
    // MARK: - Initialization
    init(columns: Int = 3, config: IMSGridConfig) {
        self.columns = columns
        self.config = config
        super.init(frame: .zero)
        setupMainStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupMainStackView() {
        mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = config.verticalSpacing
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func configure(with items: [IMSGridItem]) {
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let numberOfRows = Int(ceil(Double(items.count) / Double(columns)))
        
        for row in 0..<numberOfRows {
            let startIndex = row * columns
            let endIndex = min(startIndex + columns, items.count)
            let rowItems = Array(items[startIndex..<endIndex])
            
            // 创建包装视图来实现居中效果
            let wrapperView = UIView()
            mainStackView.addArrangedSubview(wrapperView)
            
            // 创建行StackView
            let rowStack = createRowStackView()
            wrapperView.addSubview(rowStack)
            
            // 设置行StackView的约束
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            
            if row == numberOfRows - 1 && rowItems.count < columns {
                // 最后一行且元素不足时，设置宽度约束实现居中
                let totalWidth = (CGFloat(rowItems.count) / CGFloat(columns)) * wrapperView.bounds.width
                
                NSLayoutConstraint.activate([
                    rowStack.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
                    rowStack.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
                    rowStack.heightAnchor.constraint(equalTo: wrapperView.heightAnchor),
                    rowStack.widthAnchor.constraint(equalTo: wrapperView.widthAnchor, multiplier: CGFloat(rowItems.count) / CGFloat(columns))
                ])
            } else {
                // 正常行，填充整个宽度
                NSLayoutConstraint.activate([
                    rowStack.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
                    rowStack.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
                    rowStack.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
                    rowStack.heightAnchor.constraint(equalTo: wrapperView.heightAnchor)
                ])
            }
            
            // 添加实际的items
            for item in rowItems {
                let itemStack = createItemStackView(item: item)
                rowStack.addArrangedSubview(itemStack)
            }
        }
    }
    
    // MARK: - Private Methods
    private func createRowStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = config.horizontalSpacing
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
    
    private func createItemStackView(item: IMSGridItem) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        
        let imageView = UIImageView(image: UIImage(named: item.icon))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: config.imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: config.imageSize.height)
        ])
        
        let label = UILabel()
        label.text = item.title
        label.textAlignment = .center
        label.font = config.titleFont
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        return stackView
    }
}
