import SwiftUI
import MessageUI

struct ContactSupportView: View {
    @State private var showMailComposer = false
    @State private var showMailAlert = false

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "envelope.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text("Contact Support")
                .font(.title2.weight(.bold))

            Text("We'd love to hear from you. Send us an email and we'll get back to you as soon as possible.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            VStack(alignment: .leading, spacing: 12) {
                Label("Email: \(Constants.supportEmail)", systemImage: "envelope")
                Label("Response time: within 24 hours", systemImage: "clock")
            }
            .font(.subheadline)
            .padding()
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))

            Button {
                if MFMailComposeViewController.canSendMail() {
                    showMailComposer = true
                } else {
                    showMailAlert = true
                }
            } label: {
                Text("Send Email")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue, in: RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)

            Spacer()
        }
        .padding(.top, 40)
        .sheet(isPresented: $showMailComposer) {
            MailComposeView()
        }
        .alert("Cannot Send Email", isPresented: $showMailAlert) {
            Button("Copy Email Address") {
                UIPasteboard.general.string = Constants.supportEmail
            }
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please set up an email account on your device, or email us at \(Constants.supportEmail)")
        }
    }
}

struct MailComposeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.setToRecipients([Constants.supportEmail])
        composer.setSubject("GridLens Support Request")
        composer.setMessageBody("""
        
        ---
        App: GridLens
        Version: 1.0
        Device: \(UIDevice.current.model)
        iOS: \(UIDevice.current.systemVersion)
        """, isHTML: false)
        return composer
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
