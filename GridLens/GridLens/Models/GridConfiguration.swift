import SwiftUI
import SwiftData

struct GridConfiguration {
    var gridSize: Float = 1.0
    var gridColor: GridColor = .blue
    var gridOpacity: Float = 0.6
    var unit: MeasurementUnit = .meters
    var showLabels: Bool = true
    var gridExtent: Float = 10.0

    static let `default` = GridConfiguration()

    let presetSizes: [Float] = [0.25, 0.5, 1.0, 2.0, 5.0, 10.0]
}

enum GridColor: String, CaseIterable, Codable {
    case blue, green, red, yellow, white

    var uiColor: UIColor {
        switch self {
        case .blue: return .systemBlue
        case .green: return .systemGreen
        case .red: return .systemRed
        case .yellow: return .systemYellow
        case .white: return .white
        }
    }

    var swiftUIColor: Color {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .red: return .red
        case .yellow: return .yellow
        case .white: return .white
        }
    }

    var displayName: String {
        switch self {
        case .blue: return "Blue"
        case .green: return "Green"
        case .red: return "Red"
        case .yellow: return "Yellow"
        case .white: return "White"
        }
    }
}

enum MeasurementUnit: String, CaseIterable, Codable {
    case meters = "m"
    case feet = "ft"
    case centimeters = "cm"
    case inches = "in"

    var displayName: String {
        switch self {
        case .meters: return "Meters"
        case .feet: return "Feet"
        case .centimeters: return "Centimeters"
        case .inches: return "Inches"
        }
    }

    var conversionFactor: Float {
        switch self {
        case .meters: return 1.0
        case .feet: return 3.28084
        case .centimeters: return 100.0
        case .inches: return 39.3701
        }
    }

    func convert(meters: Float) -> Float {
        return meters * conversionFactor
    }

    func toMeters(value: Float) -> Float {
        return value / conversionFactor
    }
}
