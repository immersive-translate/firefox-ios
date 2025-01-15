// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import StoreKit

class IMSIAPService {
    func observeTransactions() {
        // 设置交易监听器
        Task {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    // 处理已验证的交易
                    try await handleSuccessfulPurchase(transaction)
                case .unverified(_, let error):
                    // 处理未验证的交易
                    print("交易验证失败: \(error)")
                }
            }
        }
    }
    
    
    
    func getProduct(productId: String) async throws -> StoreKit.Product {
        let products = try await StoreKit.Product.products(for: [productId])
        guard let product = products.first else {
            throw StoreKit.Product.PurchaseError.productUnavailable
        }
        return product
    }
    
    func purchase(productId: String) async throws {
        
        // 创建购买选项
        let options: Set<StoreKit.Product.PurchaseOption> = [
            .appAccountToken(UUID()), // 可选：用于关联购买的唯一标识符
            .simulatesAskToBuyInSandbox(true), // 可选：是否在沙盒环境模拟询问购买
        ]
        
        let products = try await StoreKit.Product.products(for: [productId])
        guard let product = products.first else {
            throw StoreKit.Product.PurchaseError.productUnavailable
        }
        let result = try await product.purchase(options: options)
        switch result {
        case .success(let verificationResult):
            switch verificationResult {
            case .unverified(_, let verificationError):
                throw verificationError
            case .verified(let transaction):
                // 购买成功，处理交易
                try await handleSuccessfulPurchase(transaction)
            }
        case .userCancelled:
            throw StoreKit.StoreKitError.userCancelled
        case .pending:
            break
        @unknown default:
            break
        }
    }
    
    // 购买信息模型
    struct PurchaseInfo {
        let transactionId: UInt64
        let originalTransactionId: UInt64?
        let productId: String
        let purchaseDate: Date
        let transactionJSON: Data
        let receipt: String
    }
    
    func handleSuccessfulPurchase(_ transaction: Transaction) async throws {
        // 1. 获取交易信息
        let transactionId = transaction.id
        let originalTransactionId = transaction.originalID
        let productId = transaction.productID
        let purchaseDate = transaction.purchaseDate
        
        // 2. 获取交易的 JSON 表示
        let transactionJSON = transaction.jsonRepresentation
        
        let transactionJSONString = String(data: transactionJSON, encoding: .utf8)
        
        SKReceiptRefreshRequest().start()
        // 3. 获取 App Store 收据
        
        // 4. 将收据数据转换为 base64 字符串
        let receiptString = try await refreshReceipt()
        
        // 5. 构建购买信息
        let purchaseInfo = PurchaseInfo(
            transactionId: transactionId,
            originalTransactionId: originalTransactionId,
            productId: productId,
            purchaseDate: purchaseDate,
            transactionJSON: transactionJSON,
            receipt: receiptString
        )
        
        // 6. 发送到服务器验证
        try await sendReceiptToServer(purchaseInfo)
        
        // 7. 完成交易
        await transaction.finish()
    }
    
    func refreshReceipt() async throws -> String {
        
        class ReceiptRefreshDelegate: NSObject, SKRequestDelegate {
            typealias CompletionHandler = (Result<String, Error>) -> Void
                
            private let completion: CompletionHandler
            
            init(completion: @escaping CompletionHandler) {
                self.completion = completion
                super.init()
            }
            
            func requestDidFinish(_ request: SKRequest) {
                // 刷新完成后获取收据
                guard let receiptURL = Bundle.main.appStoreReceiptURL,
                      let receiptData = try? Data(contentsOf: receiptURL) else {
                    completion(.failure(SKError(.invalidSignature)))
                    return
                }
                
                let receiptString = receiptData.base64EncodedString()
                completion(.success(receiptString))
                objc_setAssociatedObject(request, "delegate", nil, .OBJC_ASSOCIATION_RETAIN)
            }
            
            func request(_ request: SKRequest, didFailWithError error: Error) {
                completion(.failure(error))
                objc_setAssociatedObject(request, "delegate", nil, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = SKReceiptRefreshRequest()
            let delegate = ReceiptRefreshDelegate { result in
                switch result {
                case .success(let receiptString):
                    continuation.resume(returning: receiptString)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            // 使用关联对象将delegate附加到request上，确保其生命周期
            objc_setAssociatedObject(request, "delegate", delegate, .OBJC_ASSOCIATION_RETAIN)
            
            request.delegate = delegate
            
            request.start()
        }
    }
    
    // 发送凭证到服务器
    private func sendReceiptToServer(_ purchaseInfo: PurchaseInfo) async throws {
        // 将 transactionJSON 转换为字典
        let transactionDict = try JSONSerialization.jsonObject(with: purchaseInfo.transactionJSON, options: []) as? [String: Any]
        
        // 构建请求体
        let requestBody: [String: Any] = [
            "transaction_id": purchaseInfo.transactionId,
            "original_transaction_id": purchaseInfo.originalTransactionId ?? "",
            "product_id": purchaseInfo.productId,
            "purchase_date": purchaseInfo.purchaseDate.timeIntervalSince1970,
            "transaction_data": transactionDict ?? [:],
            "receipt": purchaseInfo.receipt
        ]
        
        // 创建请求
        guard let url = URL(string: "https://test-api2.immersivetranslate.com/verify-purchase") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200...299:
                return
            default:
                throw StoreKit.Product.PurchaseError.invalidOfferSignature
            }
        }
    }
}
