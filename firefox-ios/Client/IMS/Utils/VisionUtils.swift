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
        
        // 使用正则表达式匹配任何图像格式的data URL
        if let regex = try? NSRegularExpression(pattern: "^data:image/[a-zA-Z0-9\\-\\.]+;base64,", options: []),
           let match = regex.firstMatch(in: base64, options: [], range: NSRange(location: 0, length: base64.utf16.count)) {
            // 提取前缀长度
            let prefixRange = match.range
            if let range = Range(prefixRange, in: base64) {
                // 移除前缀
                base64 = String(base64[range.upperBound...])
            }
        }
        
        // 尝试解码 base64 数据
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
        textRecognizer.process(visionImage) { [weak self] result, error in
            guard let self = self else { return }
            guard error == nil, let result = result else {
                completion(([], error))
                return
            }
            let processTextResult = self.processText(text: result)
            completion((processTextResult, nil))
        }
    }
}

extension VisionUtils {
    private func processText(text: Text) -> [(String, CGRect)] {
        var results: [(String, CGRect)] = []
        var paragraphs: [[(String, CGRect)]] = []
        var currentParagraph: [(String, CGRect)] = []
        
        results = text.blocks.compactMap({ ($0.text, $0.frame) })
        Log.d("OCR段落识别结果优化前: \(results)")
        
        // 第一步：按行收集所有文本块
        let allLines = text.blocks.flatMap { block in
            block.lines.map { line in
                return (line.text, line.frame)
            }
        }
        
        // 排序文本行（从上到下）
        let sortedLines = allLines.sorted { $0.1.minY < $1.1.minY }
        
        // 第二步：分析行间距，组织段落
        if !sortedLines.isEmpty {
            currentParagraph.append(sortedLines[0])
            
            for i in 1..<sortedLines.count {
                let previousLine = sortedLines[i-1]
                let currentLine = sortedLines[i]
                
                // 计算行间距
                let lineSpacing = currentLine.1.minY - previousLine.1.maxY
                
                // 判断是否为新段落的开始（行间距大于正常行距的1.5倍）
                // 这里的阈值可以根据实际情况调整
                let averageLineHeight = (previousLine.1.height + currentLine.1.height) / 2
                let isNewParagraph = lineSpacing > (averageLineHeight * 1.5)
                
                // 或者检查水平对齐
                let isLeftAlignmentDifferent = abs(currentLine.1.minX - previousLine.1.minX) > (averageLineHeight * 0.5)
                
                if isNewParagraph || isLeftAlignmentDifferent {
                    // 保存当前段落并开始新段落
                    if !currentParagraph.isEmpty {
                        paragraphs.append(currentParagraph)
                        currentParagraph = []
                    }
                }
                
                currentParagraph.append(currentLine)
            }
            
            // 添加最后一个段落
            if !currentParagraph.isEmpty {
                paragraphs.append(currentParagraph)
            }
        }
        
        // 第三步：合并每个段落中的文本并计算整体边界
        for paragraph in paragraphs {
            let paragraphText = paragraph.map { $0.0 }.joined(separator: " ")
            
            // 计算段落的整体边界框
            let minX = paragraph.map { $0.1.minX }.min() ?? 0
            let minY = paragraph.map { $0.1.minY }.min() ?? 0
            let maxX = paragraph.map { $0.1.maxX }.max() ?? 0
            let maxY = paragraph.map { $0.1.maxY }.max() ?? 0
            
            let paragraphFrame = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
            
            results.append((paragraphText, paragraphFrame))
        }
        
        Log.d("OCR段落识别结果优化前: \(results)")
        return results
    }
}
