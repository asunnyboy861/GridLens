import SwiftUI
import StoreKit

struct SettingsView: View {
    var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("About") {
                    HStack {
                        Text("GridLens")
                            .font(.headline)
                        Spacer()
                        Text("v1.0")
                            .foregroundStyle(.secondary)
                    }

                    NavigationLink {
                        ContactSupportView()
                    } label: {
                        Label("Contact Support", systemImage: "envelope.fill")
                    }
                }

                Section("Subscription") {
                    if purchaseManager.isPremium {
                        Label("Premium Active", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                    } else {
                        Button("Upgrade to Premium") {
                            dismiss()
                        }
                    }

                    Button("Restore Purchases") {
                        Task {
                            await purchaseManager.restorePurchases()
                        }
                    }

                    if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                        Link("Manage Subscription", destination: url)
                    }
                }

                Section("Legal") {
                    Link("Privacy Policy", destination: URL(string: Constants.privacyPolicyURL)!)
                    Link("Terms of Use", destination: URL(string: Constants.termsOfUseURL)!)
                    Link("Support", destination: URL(string: Constants.supportURL)!)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
