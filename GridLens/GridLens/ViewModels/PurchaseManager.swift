import StoreKit
import SwiftUI

@Observable
final class PurchaseManager {
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isLoading = false
    var errorMessage: String?

    var isPremium: Bool {
        !purchasedProductIDs.isEmpty
    }

    var monthlyProduct: Product? {
        products.first { $0.id == "com.zzoutuo.GridLens.monthly" }
    }

    var yearlyProduct: Product? {
        products.first { $0.id == "com.zzoutuo.GridLens.yearly" }
    }

    var lifetimeProduct: Product? {
        products.first { $0.id == "com.zzoutuo.GridLens.lifetime" }
    }

    private var transactionListener: Task<Void, Never>?

    init() {
        transactionListener = listenForTransactions()
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }

    deinit {
        transactionListener?.cancel()
    }

    func loadProducts() async {
        isLoading = true
        do {
            let storeProducts = try await Product.products(for: [
                "com.zzoutuo.GridLens.monthly",
                "com.zzoutuo.GridLens.yearly",
                "com.zzoutuo.GridLens.lifetime"
            ])
            products = storeProducts.sorted { $0.price < $1.price }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
                return true
            case .userCancelled:
                return false
            case .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updatePurchasedProducts()
                    await transaction.finish()
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func updatePurchasedProducts() async {
        var purchasedIDs: Set<String> = []
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                purchasedIDs.insert(transaction.productID)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
        purchasedProductIDs = purchasedIDs
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
