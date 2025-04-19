// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Vision
import LTXiOSUtils

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
    func detectTextRegions(from cgImage: CGImage, completion: @escaping ((result: [(text: String, rect: CGRect)], error: Error?)) -> Void) {
        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
        
        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                Log.d("文字识别出错：\(error?.localizedDescription ?? "未知错误")")
                completion(([], error))
                return
            }

            var results: [(String, CGRect)] = []

            for observation in request.results as? [VNRecognizedTextObservation] ?? [] {
                guard let candidate = observation.topCandidates(1).first else { continue }
                let boundingBox = observation.boundingBox
                let rect = self.convertBoundingBox(boundingBox, imageSize: imageSize)
                results.append((candidate.string, rect))
            }
            completion((results, nil))
        }

        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["zh-Hans", "en-US"]
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                Log.d("执行识别请求失败：\(error.localizedDescription)")
                completion(([], error))
            }
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
