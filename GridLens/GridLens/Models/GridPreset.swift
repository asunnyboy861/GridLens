import SwiftData
import Foundation

@Model
final class GridPreset {
    var name: String
    var gridSize: Float
    var gridColorRaw: String
    var gridOpacity: Float
    var unitRaw: String
    var showLabels: Bool
    var createdAt: Date

    var gridColor: GridColor {
        get { GridColor(rawValue: gridColorRaw) ?? .blue }
        set { gridColorRaw = newValue.rawValue }
    }

    var unit: MeasurementUnit {
        get { MeasurementUnit(rawValue: unitRaw) ?? .meters }
        set { unitRaw = newValue.rawValue }
    }

    init(name: String, gridSize: Float, gridColor: GridColor, gridOpacity: Float, unit: MeasurementUnit, showLabels: Bool) {
        self.name = name
        self.gridSize = gridSize
        self.gridColorRaw = gridColor.rawValue
        self.gridOpacity = gridOpacity
        self.unitRaw = unit.rawValue
        self.showLabels = showLabels
        self.createdAt = Date()
    }

    static let builtIn: [GridPreset] = [
        GridPreset(name: "Fine Detail", gridSize: 0.25, gridColor: .blue, gridOpacity: 0.6, unit: .meters, showLabels: true),
        GridPreset(name: "Standard", gridSize: 1.0, gridColor: .blue, gridOpacity: 0.6, unit: .meters, showLabels: true),
        GridPreset(name: "Large Area", gridSize: 5.0, gridColor: .green, gridOpacity: 0.5, unit: .meters, showLabels: true),
        GridPreset(name: "Imperial", gridSize: 1.0, gridColor: .yellow, gridOpacity: 0.6, unit: .feet, showLabels: true),
    ]
}
