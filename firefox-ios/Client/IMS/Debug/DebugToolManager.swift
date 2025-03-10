// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import LTXiOSUtils

final class DebugToolManager {
    static let shared = DebugToolManager()

    private init() {}

    private lazy var debugButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(floatingButtonOnClick), for: .touchUpInside)
        button.addLongPressGesture { [weak self] _ in
            self?.hide()
        }
        return button
    }()

    @objc
    private func floatingButtonOnClick() {
        let viewController = DebugToolViewController()
        RouterManager.shared.present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

extension DebugToolManager {
    func show() {
        UserDefaultsConfig.showDebugTool = true
        reload()
    }

    func hide() {
        UserDefaultsConfig.showDebugTool = false
        reload()
    }

    func reload() {
        if UserDefaultsConfig.showDebugTool {
            DispatchQueue.main.async {
                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let window = scene?.windows.first
                window?.addSubview(self.debugButton)
                self.debugButton.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().offset(-300)
                    make.left.equalToSuperview().offset(40)
                    make.width.height.equalTo(40)
                }
                window?.bringSubviewToFront(self.debugButton)
            }
        } else {
            debugButton.removeFromSuperview()
        }
    }
}
