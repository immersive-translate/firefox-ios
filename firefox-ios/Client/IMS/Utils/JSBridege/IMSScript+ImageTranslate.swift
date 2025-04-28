// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Foundation
import Kingfisher
import LTXiOSUtils
import Shared
import Storage
import WebKit
import SwiftyJSON


extension IMSScript {
    func imageLongPress(dataJSON: JSON) {
        func getImage(content: String, hideToast: Bool = true, completion: @escaping (UIImage?) -> Void) {
            if content.hasPrefix("http") {
                SVProgressHUD.show()
                KingfisherManager.shared.retrieveImage(with: URL(string: content)!) { result in
                    if hideToast {
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                        }
                    }
                    switch result {
                    case .success(let value):
                        completion(value.image)
                    case .failure(let error):
                        completion(nil)
                    }
                }
            } else {
                guard let image = VisionUtils.shared.base64ToUIImage(base64String: content) else {
                    completion(nil)
                    return
                }
                completion(image)
            }
        }
        if let value = dataJSON.string {
            Log.d(value)
            let view = ImageContextMenuView()
            if value.hasPrefix("http") && !value.hasPrefix("https://store1.immersivetranslate.com") {
                // 还没翻译
                view.typeArr = ImageContextMenuType.allCases.filter { $0 != .unTranslate }
            } else {
                // 已经翻译过
                view.typeArr = ImageContextMenuType.allCases.filter { $0 != .translate }
            }
            view.selectCallback = { type in
                switch type {
                case .unTranslate:
                    var url = ""
                    var imageId = ""
                    if value.hasPrefix("http") {
                        url = value
                    } else if let imtRange = value.range(of: "data:image/(png|jpeg|jpg|gif|webp);imt_", options: .regularExpression) {
                        let startIndex = imtRange.upperBound
                        let remaining = value[startIndex...]
                        if let endRange = remaining.firstIndex(of: ";") {
                            let id = value[startIndex ..< endRange]
                            imageId = String(id)
                        }
                    }
                    let dict: [String: Any] = [
                        "imageUrl": url,
                        "imageId": imageId
                    ]
                    self.delegate?.callTosJS(name: "restoreImage", data: dict, id: nil)
                case .feedback:
                    self.delegate?.callTosJS(name: "openImageTranslationFeedback", data: nil, id: nil)
                case .translate:
                    self.delegate?.callTosJS(name: "translateImage", data: [
                        "imageUrl": value
                    ], id: nil)
                case .save:
                    getImage(content: value) { [weak self] image in
                        guard let self = self else { return }
                        if let image = image {
                            let saver = ImageSaver()
                            saver.writeToPhotoAlbum(image: image) { error in
                                DispatchQueue.main.async {
                                    if let error = error {
                                        SVProgressHUD.toast("保存失败：\(error.localizedDescription)")
                                    } else {
                                        SVProgressHUD.toast("保存成功")
                                    }
                                }
                            }
                        }
                    }
                case .copy:
                    getImage(content: value, hideToast: false) { image in
                        if let image = image {
                            UIPasteboard.general.image = image
                            DispatchQueue.main.async {
                                SVProgressHUD.toast("复制成功")
                            }
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
    }
    
    func imageTextRecognition(id: String, dataJSON: JSON) {
        let imageId = dataJSON["imageId"].stringValue
        let imageUrl = dataJSON["imageUrl"].string
        if let imageData = dataJSON["imageData"].string, let image = VisionUtils.shared.base64ToUIImage(base64String: imageData) {
            VisionUtils.shared.detectTextRegions(from: image) { [weak self] result in
                guard let self = self else { return }
                Log.d(result)
                let data: [String: Any] = [
                    "id": id,
                    "imageId": imageId,
                    "boxes": result.result.compactMap {
                        [
                            "bounding": [$0.rect.minX, $0.rect.minY, $0.rect.width, $0.rect.height],
                            "originalText": $0.text
                        ]
                    },
                    "result": result.error == nil,
                    "errMsg": result.error?.localizedDescription ?? ""
                ]
                DispatchQueue.main.async {
                    self.delegate?.callTosJS(name: "imageTextRecognition", data: data, id: id)
                }
            }
        } else {
            let data: [String: Any] = [
                "id": id,
                "imageId": imageId,
                "boxes": [],
                "result": false,
                "errMsg": "image error"
            ]
            DispatchQueue.main.async {
                self.delegate?.callTosJS(name: "imageTextRecognition", data: data, id: id)
            }
        }
    }
}
