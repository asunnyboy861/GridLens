import SwiftUI
import ARKit
import RealityKit

struct ARCameraView: UIViewRepresentable {
    var arViewModel: ARSessionViewModel
    var gridViewModel: GridViewModel
    @Binding var arView: ARView?

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let gridRenderer = ARGridRenderer(arView: arView)
        context.coordinator.gridRenderer = gridRenderer
        arViewModel.configure(session: arView.session, gridRenderer: gridRenderer)
        arViewModel.startSession()
        DispatchQueue.main.async {
            self.arView = arView
        }
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        arViewModel.updateGridConfiguration(gridViewModel.configuration)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var gridRenderer: ARGridRenderer?
    }

    static func dismantleUIView(_ uiView: ARView, coordinator: Coordinator) {
        uiView.session.pause()
    }
}
