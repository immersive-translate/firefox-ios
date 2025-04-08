// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Foundation
import Shared
import Storage
import WebKit
import Kingfisher
import LTXiOSUtils

protocol IMSScriptDelegate: AnyObject {
    func onPageStatusAsync(status: String)
    func feedbackImage(url: String)
    func translateImage(url: String)
    func restoreImage(url: String)
}

let IMSScriptNamespace = "window.__firefox__.imtBridge"

class IMSScript: TabContentScript {
    weak var delegate: IMSScriptDelegate?
    
    static let defaultPageStatus = "Original"
    
    private var logger: Logger
    fileprivate weak var tab: Tab?
    var pageStatus = "Original"
    
    fileprivate var originalURL: URL?
    
    class func name() -> String {
        return "IMSScript"
    }

    required init(tab: Tab,
                  logger: Logger = DefaultLogger.shared) {
        self.tab = tab
        self.logger = logger
    }

    func scriptMessageHandlerNames() -> [String]? {
        return ["imsScriptMessageHandler"]
    }
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceiveScriptMessage message: WKScriptMessage
    ) {
        guard let res = message.body as? [String: Any],
              let type = res["type"] as? String
        else { return }
        switch type {
        case "getPageStatusAsync":
            if let value = res["value"] as? String {
                pageStatus = value
                self.delegate?.onPageStatusAsync(status: value)
            }
        case "imageLongPress":
            func getImage(content: String, completion: @escaping (UIImage?) -> Void) {
                if content.hasPrefix("http") {
                    SVProgressHUD.show()
                    KingfisherManager.shared.retrieveImage(with: URL(string: content)!) { result in
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                        }
                        switch result {
                        case .success(let value):
                            completion(value.image)
                        case .failure(let error):
                            completion(nil)
                        }
                    }
                } else {
                    guard let data = Data(base64Encoded: content),
                          let image = UIImage(data: data) else {
                        completion(nil)
                        return
                    }
                    completion(image)
                }
            }
            if let value = res["value"] as? String {
                Log.d(value)
                let view = ImageContextMenuView()
                if value.hasPrefix("http") && !value.hasPrefix("https://store1.immersivetranslate.com") {
                    // 还没翻译
                    view.typeArr = ImageContextMenuType.allCases.filter({ $0 != .unTranslate })
                } else {
                    // 已经翻译过
                    view.typeArr = ImageContextMenuType.allCases.filter({ $0 != .translate })
                }
                view.selectCallback = { type in
                    switch type {
                    case .unTranslate:
                        self.delegate?.restoreImage(url: value)
                    case .feedback:
                        self.delegate?.feedbackImage(url: value)
                    case .translate:
                        self.delegate?.translateImage(url: value)
                    case .save:
                        getImage(content: value) { image in
                            if let image = image {
                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            }
                        }
                    case .copy:
                        getImage(content: value) { image in
                            if let image = image {
                                UIPasteboard.general.image = image
                            }
                        }
                    case .share:
                        getImage(content: value) { image in
                            if let image = image {
                                let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                                UIViewController.tx.topViewController()?.present(activityVC, animated: true)
                            }
                        }
                    }
                }
                view.show()
            }
        default:
            break
        }
    }
}
