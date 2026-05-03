import SwiftUI
import SwiftData

struct GridControlsView: View {
    var gridViewModel: GridViewModel
    var purchaseManager: PurchaseManager
    @Binding var showPaywall: Bool
    var onCapture: () -> Void
    @State private var showPresetPicker = false

    var body: some View {
        VStack(spacing: 12) {
            gridSizeSelector

            HStack(spacing: 16) {
                gridColorPicker
                unitPicker
                opacitySlider
                labelsToggle
            }

            HStack(spacing: 20) {
                presetButton
                captureButton
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    private var gridSizeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(gridViewModel.configuration.presetSizes.enumerated()), id: \.offset) { index, size in
                    let converted = gridViewModel.configuration.unit.convert(meters: size)
                    let label = String(format: "%.2f%@", converted, gridViewModel.configuration.unit.rawValue)

                    Button {
                        if !purchaseManager.isPremium && index > 1 {
                            showPaywall = true
                            return
                        }
                        gridViewModel.selectPresetSize(at: index)
                    } label: {
                        Text(label)
                            .font(.subheadline.weight(
                                gridViewModel.selectedPresetSizeIndex == index ? .bold : .regular
                            ))
                            .foregroundStyle(
                                gridViewModel.selectedPresetSizeIndex == index ? .white : .white.opacity(0.7)
                            )
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                gridViewModel.selectedPresetSizeIndex == index
                                ? Color.blue
                                : Color.white.opacity(0.15),
                                in: Capsule()
                            )
                    }
                    .accessibilityLabel("Grid size \(label)")
                }
            }
        }
    }

    private var gridColorPicker: some View {
        Menu {
            ForEach(GridColor.allCases, id: \.self) { color in
                Button {
                    if !purchaseManager.isPremium && color != .blue {
                        showPaywall = true
                        return
                    }
                    gridViewModel.setGridColor(color)
                } label: {
                    Label(color.displayName, systemImage: "circle.fill")
                        .foregroundStyle(color.swiftUIColor)
                }
            }
        } label: {
            Image(systemName: "paintpalette.fill")
                .font(.title3)
                .foregroundStyle(gridViewModel.configuration.gridColor.swiftUIColor)
                .padding(10)
                .background(.white.opacity(0.15), in: Circle())
        }
        .accessibilityLabel("Grid Color")
    }

    private var unitPicker: some View {
        Menu {
            ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                Button {
                    if !purchaseManager.isPremium && unit != .meters {
                        showPaywall = true
                        return
                    }
                    gridViewModel.setUnit(unit)
                } label: {
                    Text(unit.displayName)
                }
            }
        } label: {
            Text(gridViewModel.configuration.unit.rawValue)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(.white.opacity(0.15), in: Capsule())
        }
        .accessibilityLabel("Measurement Unit")
    }

    private var opacitySlider: some View {
        VStack(spacing: 4) {
            Image(systemName: "circle.lefthalf.filled")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
            Slider(value: Binding(
                get: { gridViewModel.configuration.gridOpacity },
                set: { gridViewModel.configuration.gridOpacity = $0 }
            ), in: 0.1...1.0)
                .tint(.white)
                .frame(width: 80)
        }
        .accessibilityLabel("Grid Opacity")
    }

    private var labelsToggle: some View {
        Button {
            if !purchaseManager.isPremium {
                showPaywall = true
                return
            }
            gridViewModel.toggleLabels()
        } label: {
            Image(systemName: gridViewModel.configuration.showLabels ? "text.bubble.fill" : "text.bubble")
                .font(.title3)
                .foregroundStyle(.white)
                .padding(10)
                .background(.white.opacity(0.15), in: Circle())
        }
        .accessibilityLabel(gridViewModel.configuration.showLabels ? "Hide Labels" : "Show Labels")
    }

    private var presetButton: some View {
        Button {
            showPresetPicker = true
        } label: {
            Image(systemName: "list.bullet.circle.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .padding(12)
                .background(.white.opacity(0.15), in: Circle())
        }
        .accessibilityLabel("Grid Presets")
        .sheet(isPresented: $showPresetPicker) {
            GridPresetPicker(gridViewModel: gridViewModel)
        }
    }

    private var captureButton: some View {
        Button {
            onCapture()
        } label: {
            Image(systemName: "camera.circle.fill")
                .font(.system(size: 44))
                .foregroundStyle(.white)
        }
        .accessibilityLabel("Capture Screenshot")
    }
}
