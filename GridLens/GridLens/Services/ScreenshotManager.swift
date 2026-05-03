import UIKit
import Photos
import ARKit
import RealityKit
import UniformTypeIdentifiers
import CoreLocation

final class ScreenshotManager {
    static let shared = ScreenshotManager()

    private init() {}

    func captureScreenshot(from arView: ARView, location: CLLocation?) async -> Bool {
        guard let pixelBuffer = arView.session.currentFrame?.capturedImage else { return false }

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return false }

        let uiImage = UIImage(cgImage: cgImage)
        let finalImage = overlayGridOnImage(uiImage)

        var metadata: [String: Any] = [:]
        if let location {
            let gpsMetadata = createGPSMetadata(from: location)
            metadata.merge(gpsMetadata) { _, new in new }
        }

        return await saveToPhotos(finalImage, metadata: metadata)
    }

    private func overlayGridOnImage(_ image: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { context in
            image.draw(at: .zero)
        }
    }

    private func createGPSMetadata(from location: CLLocation) -> [String: Any] {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        return [
            kCGImagePropertyGPSDictionary as String: [
                kCGImagePropertyGPSLatitude as String: abs(latitude),
                kCGImagePropertyGPSLatitudeRef as String: latitude >= 0 ? "N" : "S",
                kCGImagePropertyGPSLongitude as String: abs(longitude),
                kCGImagePropertyGPSLongitudeRef as String: longitude >= 0 ? "E" : "W",
                kCGImagePropertyGPSAltitude as String: location.altitude,
                kCGImagePropertyGPSTimeStamp as String: ISO8601DateFormatter().string(from: location.timestamp),
            ]
        ]
    }

    private func saveToPhotos(_ image: UIImage, metadata: [String: Any]) async -> Bool {
        do {
            try await PHPhotoLibrary.shared().performChanges {
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                request.creationDate = Date()
            }
            return true
        } catch {
            return false
        }
    }
}
