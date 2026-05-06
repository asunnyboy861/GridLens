import SwiftUI
import SwiftData
import ARKit

@Observable
final class ARSessionViewModel: NSObject, ARSessionDelegate {
    var isSessionRunning = false
    var isPlaneDetected = false
    var detectedPlaneAnchor: ARPlaneAnchor?
    var showPlaneSearchingHint = true
    var errorMessage: String?
    var showUnsupportedDeviceAlert = false

    private var session: ARSession?
    private var gridRenderer: ARGridRenderer?

    var gridConfiguration = GridConfiguration.default

    static let shared = ARSessionViewModel()

    func configure(session: ARSession, gridRenderer: ARGridRenderer) {
        self.session = session
        self.gridRenderer = gridRenderer
        session.delegate = self
    }

    func startSession() {
        #if targetEnvironment(simulator)
        showPlaneSearchingHint = false
        isSessionRunning = true
        isPlaneDetected = true
        #else
        guard ARWorldTrackingConfiguration.isSupported else {
            showUnsupportedDeviceAlert = true
            return
        }

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic

        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }

        session?.run(configuration)
        isSessionRunning = true
        showPlaneSearchingHint = true
        #endif
    }

    func stopSession() {
        session?.pause()
        isSessionRunning = false
        isPlaneDetected = false
        detectedPlaneAnchor = nil
    }

    func resetSession() {
        guard let session = session else { return }
        session.run(session.configuration ?? ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
        isPlaneDetected = false
        detectedPlaneAnchor = nil
        showPlaneSearchingHint = true
        gridRenderer?.removeAllGrids()
    }

    func updateGrid() {
        guard let planeAnchor = detectedPlaneAnchor else { return }
        gridRenderer?.updateGrid(
            on: planeAnchor,
            configuration: gridConfiguration
        )
    }

    func updateGridConfiguration(_ config: GridConfiguration) {
        gridConfiguration = config
        updateGrid()
    }

    nonisolated func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        MainActor.assumeIsolated {
            for anchor in anchors {
                if let planeAnchor = anchor as? ARPlaneAnchor {
                    detectedPlaneAnchor = planeAnchor
                    isPlaneDetected = true
                    showPlaneSearchingHint = false
                    gridRenderer?.addGrid(on: planeAnchor, configuration: gridConfiguration)
                }
            }
        }
    }

    nonisolated func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        MainActor.assumeIsolated {
            for anchor in anchors {
                if let planeAnchor = anchor as? ARPlaneAnchor {
                    if detectedPlaneAnchor?.identifier == planeAnchor.identifier {
                        detectedPlaneAnchor = planeAnchor
                        gridRenderer?.updateGrid(on: planeAnchor, configuration: gridConfiguration)
                    }
                }
            }
        }
    }

    nonisolated func session(_ session: ARSession, didFailWithError error: Error) {
        MainActor.assumeIsolated {
            errorMessage = error.localizedDescription
        }
    }
}
