// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import StoreKit

class IMSIAPAppleService {
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
    
    func getProducts(_ productIds: [String]) async throws -> [StoreKit.Product] {
        let products = try await StoreKit.Product.products(for: Set(productIds))
        return products
    }
    
    func getProduct(productId: String) async throws -> StoreKit.Product {
        let products = try await getProducts([productId])
        guard let product = products.first else {
            throw StoreKit.Product.PurchaseError.productUnavailable
        }
        return product
    }
    
    func purchase(productId: String, orderNo: String) async throws {
        guard let accountToken = UUID(uuidString: orderNo) else {
            throw StoreKit.Product.PurchaseError.missingOfferParameters
        }
        // Get product using existing method
        let product = try await getProduct(productId: productId)
        
        // Create purchase options with outTradeNo as appAccountToken
        let options: Set<StoreKit.Product.PurchaseOption> = [
            .appAccountToken(accountToken),
            .simulatesAskToBuyInSandbox(false),
        ]
        
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
    
    func handleSuccessfulPurchase(_ transaction: Transaction) async throws {
        await transaction.finish()
    }
    
    static func formatPrice(product: StoreKit.Product, price: Decimal? = nil) -> String {
        let price = (price ?? product.price) as NSDecimalNumber
        let locale = product.priceFormatStyle.locale
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.currencyCode = locale.currencyCode
        formatter.currencySymbol = locale.currencySymbol
        
        return formatter.string(from: price) ?? ""
    }
}
