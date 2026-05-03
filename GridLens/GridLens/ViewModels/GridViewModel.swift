import SwiftUI
import SwiftData

@Observable
final class GridViewModel {
    var configuration = GridConfiguration.default
    var selectedPresetSizeIndex: Int = 2

    var displayGridSize: String {
        let converted = configuration.unit.convert(meters: configuration.gridSize)
        return String(format: "%.2f %@", converted, configuration.unit.rawValue)
    }

    func selectPresetSize(at index: Int) {
        guard index >= 0 && index < configuration.presetSizes.count else { return }
        selectedPresetSizeIndex = index
        configuration.gridSize = configuration.presetSizes[index]
    }

    func setGridColor(_ color: GridColor) {
        configuration.gridColor = color
    }

    func setUnit(_ unit: MeasurementUnit) {
        let currentMeters = configuration.gridSize
        configuration.unit = unit
        configuration.gridSize = currentMeters
    }

    func toggleLabels() {
        configuration.showLabels.toggle()
    }

    func createPreset(name: String, modelContext: ModelContext) {
        let preset = GridPreset(
            name: name,
            gridSize: configuration.gridSize,
            gridColor: configuration.gridColor,
            gridOpacity: configuration.gridOpacity,
            unit: configuration.unit,
            showLabels: configuration.showLabels
        )
        modelContext.insert(preset)
        try? modelContext.save()
    }

    func applyPreset(_ preset: GridPreset) {
        configuration.gridSize = preset.gridSize
        configuration.gridColor = preset.gridColor
        configuration.gridOpacity = preset.gridOpacity
        configuration.unit = preset.unit
        configuration.showLabels = preset.showLabels

        if let index = configuration.presetSizes.firstIndex(of: preset.gridSize) {
            selectedPresetSizeIndex = index
        }
    }
}
