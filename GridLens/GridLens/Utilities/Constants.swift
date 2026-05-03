import Foundation

enum Constants {
    static let appName = "GridLens"
    static let bundleId = "com.zzoutuo.GridLens"
    static let supportEmail = "support@zzoutuo.com"
    static let privacyPolicyURL = "https://zzoutuo.github.io/GridLens/privacy"
    static let termsOfUseURL = "https://zzoutuo.github.io/GridLens/terms"
    static let supportURL = "https://zzoutuo.github.io/GridLens/support"

    enum IAP {
        static let monthlyId = "com.zzoutuo.GridLens.monthly"
        static let yearlyId = "com.zzoutuo.GridLens.yearly"
        static let lifetimeId = "com.zzoutuo.GridLens.lifetime"
    }

    enum Grid {
        static let defaultSize: Float = 1.0
        static let defaultOpacity: Float = 0.6
        static let defaultExtent: Float = 10.0
        static let maxLineCount = 500
        static let minGridSize: Float = 0.25
        static let maxGridSize: Float = 10.0
    }

    enum AR {
        static let planeSearchingHint = "Move your iPhone slowly to scan a flat surface"
        static let unsupportedDeviceMessage = "ARKit is not supported on this device. GridLens requires an iPhone 6s or later with iOS 17.0+."
    }
}
