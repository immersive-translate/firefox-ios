// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Vision
import LTXiOSUtils
import MLKitVision
import MLKitTextRecognition

final class VisionUtils {
    static let shared = VisionUtils()
    
    private init() {}
    
    func base64ToUIImage(base64String: String) -> UIImage? {
        var base64 = base64String
        if base64.hasPrefix("data:image/png;base64,") {
            base64 = String(base64.dropFirst("data:image/png;base64,".count))
        }
        if let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
    
    /// 识别图像中的文字并返回文字与其在图像中的位置（像素坐标）
    func detectTextRegions(from image: UIImage, completion: @escaping ((result: [(text: String, rect: CGRect)], error: Error?)) -> Void) {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        let options = TextRecognizerOptions()
        let textRecognizer = TextRecognizer.textRecognizer(options: options)
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                completion(([], error))
                return
            }
            var results: [(String, CGRect)] = []
            for block in result.blocks {
                let blockText = block.text.replacingOccurrences(of: "\n", with: " ")
                let blockFrame = block.frame
                results.append((blockText, blockFrame))
            }
            Log.d("OCR识别结果: \(results)")
            completion((results, nil))
        }
    }

    /// 将 Vision 返回的 boundingBox（归一化坐标）转换为图像像素坐标
    private func convertBoundingBox(_ boundingBox: CGRect, imageSize: CGSize) -> CGRect {
        let x = boundingBox.origin.x * imageSize.width
        let height = boundingBox.size.height * imageSize.height
        let y = (1 - boundingBox.origin.y - boundingBox.size.height) * imageSize.height
        let width = boundingBox.size.width * imageSize.width
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
