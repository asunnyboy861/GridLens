import SwiftUI
import StoreKit

struct PaywallView: View {
    var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTier: SubscriptionTier = .yearly
    @State private var isPurchasing = false

    enum SubscriptionTier: String, CaseIterable {
        case monthly, yearly, lifetime
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "grid")
                        .font(.system(size: 50))
                        .foregroundStyle(.blue)

                    Text("Unlock GridLens Premium")
                        .font(.title.weight(.bold))

                    Text("Get full access to all grid features for your professional work")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    VStack(spacing: 12) {
                        tierCard(.monthly)
                        tierCard(.yearly)
                        tierCard(.lifetime)
                    }
                    .padding(.horizontal, 20)

                    Button {
                        purchaseSelectedTier()
                    } label: {
                        if isPurchasing {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Subscribe Now")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color.blue, in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 20)
                    .disabled(isPurchasing)

                    Button {
                        Task {
                            await purchaseManager.restorePurchases()
                        }
                    } label: {
                        Text("Restore Purchases")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        featureRow("All grid sizes (0.25m - 10m)")
                        featureRow("Multiple grid colors")
                        featureRow("Grid labels with coordinates")
                        featureRow("Unit switching (m, ft, cm, in)")
                        featureRow("GPS-tagged screenshots")
                        featureRow("Custom grid presets")
                    }
                    .padding()
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 20)

                    Text("Payment will be charged to your Apple ID account at confirmation of purchase. Subscriptions automatically renew unless it is canceled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase.")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 20)

                    HStack(spacing: 24) {
                        Link("Privacy Policy", destination: URL(string: Constants.privacyPolicyURL)!)
                        Link("Terms of Use", destination: URL(string: Constants.termsOfUseURL)!)
                    }
                    .font(.caption)
                    .padding(.bottom, 20)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func tierCard(_ tier: SubscriptionTier) -> some View {
        Button {
            selectedTier = tier
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(tierDisplayName(tier))
                            .font(.subheadline.weight(.semibold))
                        if tier == .yearly {
                            Text("Best Value")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(.green, in: Capsule())
                        }
                    }
                    Text(tierPrice(tier))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if selectedTier == tier {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                        .font(.title3)
                } else {
                    Image(systemName: "circle")
                        .foregroundStyle(.secondary)
                        .font(.title3)
                }
            }
            .padding()
            .background(
                selectedTier == tier
                ? Color.blue.opacity(0.1)
                : Color(.systemGray6),
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedTier == tier ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .accessibilityLabel("\(tierDisplayName(tier)) - \(tierPrice(tier))")
    }

    private func tierDisplayName(_ tier: SubscriptionTier) -> String {
        switch tier {
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        case .lifetime: return "Lifetime"
        }
    }

    private func tierPrice(_ tier: SubscriptionTier) -> String {
        switch tier {
        case .monthly:
            return purchaseManager.monthlyProduct?.displayPrice ?? "$4.99/month"
        case .yearly:
            return purchaseManager.yearlyProduct?.displayPrice ?? "$29.99/year"
        case .lifetime:
            return purchaseManager.lifetimeProduct?.displayPrice ?? "$59.99 once"
        }
    }

    private func purchaseSelectedTier() {
        isPurchasing = true
        Task {
            let product: Product?
            switch selectedTier {
            case .monthly: product = purchaseManager.monthlyProduct
            case .yearly: product = purchaseManager.yearlyProduct
            case .lifetime: product = purchaseManager.lifetimeProduct
            }

            if let product {
                let success = await purchaseManager.purchase(product)
                if success {
                    dismiss()
                }
            }
            isPurchasing = false
        }
    }

    private func featureRow(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.caption)
            Text(text)
                .font(.subheadline)
        }
    }
}
