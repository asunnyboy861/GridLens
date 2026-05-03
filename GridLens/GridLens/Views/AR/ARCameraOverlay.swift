import SwiftUI
import RealityKit

struct ARCameraOverlay: View {
    var arViewModel: ARSessionViewModel
    var gridViewModel: GridViewModel
    var purchaseManager: PurchaseManager
    @Binding var showSettings: Bool
    @Binding var showPaywall: Bool
    @Binding var showScreenshotFlash: Bool
    @State private var arViewForCapture: ARView?

    var body: some View {
        VStack {
            HStack {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .accessibilityLabel("Settings")

                Spacer()

                if arViewModel.isPlaneDetected {
                    Label("Plane Detected", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                }

                Spacer()

                Button {
                    arViewModel.resetSession()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .accessibilityLabel("Reset AR Session")
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer()

            GridControlsView(
                gridViewModel: gridViewModel,
                purchaseManager: purchaseManager,
                showPaywall: $showPaywall,
                onCapture: captureScreenshot
            )
        }
    }

    private func captureScreenshot() {
        showScreenshotFlash = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            showScreenshotFlash = false
        }

        Task {
            let location = LocationManager.shared.currentLocation
            if let arView = arViewForCapture {
                _ = await ScreenshotManager.shared.captureScreenshot(
                    from: arView,
                    location: location
                )
            }
        }
    }
}
