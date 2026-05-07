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
        products.first { $0.id == ProductID.monthly }
    }

    var yearlyProduct: Product? {
        products.first { $0.id == ProductID.yearly }
    }

    var lifetimeProduct: Product? {
        products.first { $0.id == ProductID.lifetime }
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
        errorMessage = nil
        do {
            let storeProducts = try await Product.products(for: [
                ProductID.monthly,
                ProductID.yearly,
                ProductID.lifetime
            ])
            products = storeProducts.sorted { $0.price < $1.price }
            if products.isEmpty {
                errorMessage = "Unable to load subscription products. Please check your internet connection and try again."
            }
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
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
                errorMessage = "Purchase is pending approval."
                return false
            @unknown default:
                return false
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            return false
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            errorMessage = "Restore failed: \(error.localizedDescription)"
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                switch result {
                case .verified(let transaction):
                    _ = await MainActor.run {
                        Task {
                            await self.updatePurchasedProducts()
                        }
                    }
                    await transaction.finish()
                case .unverified:
                    await MainActor.run {
                        self.errorMessage = "Transaction verification failed."
                    }
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
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
        await MainActor.run {
            self.purchasedProductIDs = purchasedIDs
        }
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

struct ProductID {
    static let monthly = "com.zzoutuo.GridLens.monthly"
    static let yearly = "com.zzoutuo.GridLens.yearly"
    static let lifetime = "com.zzoutuo.GridLens.lifetime"
}
