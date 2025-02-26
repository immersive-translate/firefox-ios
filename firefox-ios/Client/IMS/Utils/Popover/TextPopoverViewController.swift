// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit

extension UIView {
    /// 显示一个包含简单文本的popover
        /// - Parameters:
        ///   - text: 要显示的文本
        ///   - sourceRect: popover箭头指向的区域
        ///   - arrowDirections: 允许的箭头方向
        ///   - width: popover的宽度
        ///   - font: 文本字体
        func showTextPopover(
            text: String,
            sourceRect: CGRect? = nil,
            arrowDirections: UIPopoverArrowDirection = .any,
            width: CGFloat = 200,
            font: UIFont = .systemFont(ofSize: 16),
            completion: (() -> Void)? = nil
        ) {
            let contentVC = TextPopoverViewController(text: text, font: font, width: width)
            showPopover(
                with: contentVC,
                sourceRect: sourceRect,
                arrowDirections: arrowDirections,
                completion: completion
            )
        }
}

class TextPopoverViewController: UIViewController {
    private let text: String
    private let font: UIFont
    private let width: CGFloat
    
    init(text: String, font: UIFont, width: CGFloat) {
        self.text = text
        self.font = font
        self.width = width
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = font
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        // 计算文本高度
        let size = textLabel.sizeThatFits(CGSize(width: width - 32, height: CGFloat.greatestFiniteMagnitude))
        preferredContentSize = CGSize(width: width, height: size.height + 32)
    }
}
