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
        if let regex = try? NSRegularExpression(pattern: #"^data:image/[a-zA-Z0-9\-\.]+(?:;[a-zA-Z0-9_\-=]+)*;base64,"#, options: []),
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
        
        // 第一步：收集并过滤文本块
        let rawBlocks = text.blocks.compactMap({ ($0.text, $0.frame) })
        Log.d("OCR段落识别结果优化前(块级): \(rawBlocks)")
        
        // 过滤可能的页码或无关内容
        let filteredBlocks = rawBlocks.filter { block in
            // 过滤纯数字且长度短的块（如页码）
            if block.0.count <= 3 && block.0.allSatisfy({ $0.isNumber }) {
                return false
            }
            return true
        }
        
        Log.d("过滤后的文本块数: \(filteredBlocks.count)")
        
        // 处理简单场景：少量文本块
        if filteredBlocks.count <= 2 {
            // 按照Y坐标排序文本块
            let sortedBlocks = filteredBlocks.sorted { $0.1.minY < $1.1.minY }
            
            // 检查块之间是否应该合并
            if filteredBlocks.count == 2 && !shouldMergeBlocks(sortedBlocks[0], sortedBlocks[1]) {
                // 如果不应该合并，分别处理每个块
                for block in sortedBlocks {
                    let processedText = block.0.replacingOccurrences(of: "\n", with: containsChineseCharacters(block.0) ? "" : " ")
                    results.append((processedText, block.1))
                }
            } else {
                // 合并处理文本块
                for i in 0..<sortedBlocks.count {
                    let block = sortedBlocks[i]
                    let processedText = block.0.replacingOccurrences(of: "\n", with: containsChineseCharacters(block.0) ? "" : " ")
                    
                    // 如果是第一个块或与前一个块距离太远，创建新结果
                    if i == 0 || results.isEmpty {
                        results.append((processedText, block.1))
                    } else {
                        // 检查是否应该与前一个结果合并
                        let prevResult = results[results.count - 1]
                        if shouldMergeBlocks((prevResult.0, prevResult.1), (processedText, block.1)) {
                            // 合并文本
                            let lastChar = prevResult.0.last
                            let firstChar = processedText.first
                            
                            let lastCharIsLatinOrDigit = lastChar.map { $0.isLetter || $0.isNumber } ?? false
                            let firstCharIsLatinOrDigit = firstChar.map { $0.isLetter || $0.isNumber } ?? false
                            
                            var mergedText = prevResult.0
                            if lastCharIsLatinOrDigit && firstCharIsLatinOrDigit {
                                mergedText += " "
                            }
                            mergedText += processedText
                            
                            // 更新边界框
                            let minX = min(prevResult.1.minX, block.1.minX)
                            let minY = min(prevResult.1.minY, block.1.minY)
                            let maxX = max(prevResult.1.maxX, block.1.maxX)
                            let maxY = max(prevResult.1.maxY, block.1.maxY)
                            
                            let mergedRect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
                            results[results.count - 1] = (mergedText, mergedRect)
                        } else {
                            // 添加为新结果
                            results.append((processedText, block.1))
                        }
                    }
                }
            }
        } else {
            // 处理多个文本块的场景
            var paragraphs: [[(String, CGRect)]] = []
            var currentParagraph: [(String, CGRect)] = []
            
            // 收集所有行文本
            let allLines = text.blocks.flatMap { block in
                block.lines.map { line in
                    return (line.text, line.frame)
                }
            }
            
            Log.d("OCR识别总行数: \(allLines.count)")
            
            // 过滤页码等干扰内容
            let filteredLines = allLines.filter { line in
                return !(line.0.count <= 3 && line.0.allSatisfy({ $0.isNumber }))
            }
            
            // 排序文本行（从上到下）
            let sortedLines = filteredLines.sorted { $0.1.minY < $1.1.minY }
            
            // 分析行间距和布局特征，组织段落
            if !sortedLines.isEmpty {
                currentParagraph.append(sortedLines[0])
                
                for i in 1..<sortedLines.count {
                    let previousLine = sortedLines[i-1]
                    let currentLine = sortedLines[i]
                    
                    // 判断是否应该分段
                    let shouldBreak = shouldBreakAtLine(previousLine: previousLine, currentLine: currentLine)
                    
                    if shouldBreak {
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
            
            Log.d("OCR识别段落数: \(paragraphs.count)")
            
            // 合并每个段落中的文本并计算整体边界
            for (index, paragraph) in paragraphs.enumerated() {
                // 对中文文本，不添加空格；对英文和数字，需要考虑添加空格
                var paragraphText = ""
                for (i, line) in paragraph.enumerated() {
                    if i > 0 {
                        // 检查是否需要添加空格
                        let lastChar = paragraph[i-1].0.last
                        let firstChar = line.0.first
                        
                        let lastCharIsLatinOrDigit = lastChar.map { $0.isLetter || $0.isNumber } ?? false
                        let firstCharIsLatinOrDigit = firstChar.map { $0.isLetter || $0.isNumber } ?? false
                        
                        if lastCharIsLatinOrDigit && firstCharIsLatinOrDigit {
                            paragraphText += " "
                        }
                    }
                    paragraphText += line.0
                }
                
                // 计算段落的整体边界框
                let minX = paragraph.map { $0.1.minX }.min() ?? 0
                let minY = paragraph.map { $0.1.minY }.min() ?? 0
                let maxX = paragraph.map { $0.1.maxX }.max() ?? 0
                let maxY = paragraph.map { $0.1.maxY }.max() ?? 0
                
                let paragraphFrame = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
                
                Log.d("段落\(index+1)文本: \(paragraphText)")
                Log.d("段落\(index+1)边框: \(paragraphFrame)")
                
                results.append((paragraphText, paragraphFrame))
            }
        }
        
        // 根据Y坐标排序最终结果，保持从上到下的阅读顺序
        results.sort { $0.1.minY < $1.1.minY }
        
        Log.d("OCR段落识别结果优化后: \(results)")
        return results
    }
    
    // 判断两个文本块是否应该合并
    private func shouldMergeBlocks(_ block1: (String, CGRect), _ block2: (String, CGRect)) -> Bool {
        // 计算两块之间的垂直距离
        let topBlock = block1.1.minY < block2.1.minY ? block1 : block2
        let bottomBlock = block1.1.minY < block2.1.minY ? block2 : block1
        let verticalDistance = bottomBlock.1.minY - topBlock.1.maxY
        
        // 计算平均块高
        let avgHeight = (block1.1.height + block2.1.height) / 2
        
        // 如果垂直距离太大，不合并
        if verticalDistance > (avgHeight * 2.0) {
            return false
        }
        
        // 如果两块中有一个是全大写且另一个不是，可能是不同类型的文本
        let block1AllCaps = block1.0.uppercased() == block1.0 && block1.0.contains(where: { $0.isLetter })
        let block2AllCaps = block2.0.uppercased() == block2.0 && block2.0.contains(where: { $0.isLetter })
        
        if block1AllCaps != block2AllCaps {
            return false
        }
        
        // 检查水平位置 - 如果水平差异太大，不合并
        let xDifference = abs(block1.1.midX - block2.1.midX)
        if xDifference > (max(block1.1.width, block2.1.width) * 0.5) {
            return false
        }
        
        return true
    }
    
    // 判断是否应该在两行之间分段
    private func shouldBreakAtLine(previousLine: (String, CGRect), currentLine: (String, CGRect)) -> Bool {
        // 计算行间距
        let lineSpacing = currentLine.1.minY - previousLine.1.maxY
        let averageLineHeight = (previousLine.1.height + currentLine.1.height) / 2
        
        // 检查空间距离
        let isFarApart = lineSpacing > (averageLineHeight * 2.5)
        
        // 检查水平对齐
        let xDifference = abs(currentLine.1.minX - previousLine.1.minX)
        let isAlignmentVeryDifferent = xDifference > (averageLineHeight * 0.8)
        
        // 检查大小写特征
        let prevAllCaps = previousLine.0.uppercased() == previousLine.0 && previousLine.0.contains(where: { $0.isLetter })
        let currAllCaps = currentLine.0.uppercased() == currentLine.0 && currentLine.0.contains(where: { $0.isLetter })
        let capsChange = prevAllCaps != currAllCaps
        
        // 检查宽度比
        let widthRatio = min(currentLine.1.width, previousLine.1.width) / max(currentLine.1.width, previousLine.1.width)
        let isWidthSimilar = widthRatio > 0.7
        
        // 基于格式、间距等因素判断是否分段
        return isFarApart || (isAlignmentVeryDifferent && !isWidthSimilar) || capsChange
    }
    
    // 检查文本是否包含中文字符
    private func containsChineseCharacters(_ text: String) -> Bool {
        let pattern = "[\u{4e00}-\u{9fff}]"
        return text.range(of: pattern, options: .regularExpression) != nil
    }
}
