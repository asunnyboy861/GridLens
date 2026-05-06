import SwiftUI
import ARKit
import RealityKit
import SwiftData

struct ContentView: View {
    @State private var arViewModel = ARSessionViewModel.shared
    @State private var gridViewModel = GridViewModel()
    @State private var purchaseManager = PurchaseManager()
    @State private var showSettings = false
    @State private var showPaywall = false
    @State private var showScreenshotFlash = false
    @State private var arViewForCapture: ARView?

    var body: some View {
        ZStack {
            ARCameraView(
                arViewModel: arViewModel,
                gridViewModel: gridViewModel,
                arView: $arViewForCapture
            )
            .ignoresSafeArea()

            ARCameraOverlay(
                arViewModel: arViewModel,
                gridViewModel: gridViewModel,
                purchaseManager: purchaseManager,
                showSettings: $showSettings,
                showPaywall: $showPaywall,
                showScreenshotFlash: $showScreenshotFlash,
                arViewForCapture: arViewForCapture
            )

            if showScreenshotFlash {
                Color.white
                    .ignoresSafeArea()
                    .opacity(showScreenshotFlash ? 0.8 : 0)
                    .animation(.easeOut(duration: 0.15), value: showScreenshotFlash)
            }

            if arViewModel.showPlaneSearchingHint {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "move.3d")
                            .foregroundStyle(.white)
                        Text(Constants.AR.planeSearchingHint)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.bottom, 180)
                }
                .transition(.opacity)
            }
        }
        .alert("AR Not Supported", isPresented: $arViewModel.showUnsupportedDeviceAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(Constants.AR.unsupportedDeviceMessage)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(purchaseManager: purchaseManager)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(purchaseManager: purchaseManager)
        }
    }
}
