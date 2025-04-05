// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Vision
import LTXiOSUtils

struct VisionUtils {
    /// 识别图像中的文字并返回文字与其在图像中的位置（像素坐标）
    func detectTextRegions(from image: UIImage, completion: @escaping ([(text: String, rect: CGRect)]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }

        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
        
        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                Log.d("文字识别出错：\(error?.localizedDescription ?? "未知错误")")
                completion([])
                return
            }

            var results: [(String, CGRect)] = []

            for observation in request.results as? [VNRecognizedTextObservation] ?? [] {
                guard let candidate = observation.topCandidates(1).first else { continue }
                let boundingBox = observation.boundingBox
                let rect = self.convertBoundingBox(boundingBox, imageSize: imageSize)
                results.append((candidate.string, rect))
            }
            completion(results)
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
                completion([])
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
