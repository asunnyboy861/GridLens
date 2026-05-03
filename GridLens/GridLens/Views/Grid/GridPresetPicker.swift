import SwiftUI
import SwiftData

struct GridPresetPicker: View {
    var gridViewModel: GridViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GridPreset.createdAt) var presets: [GridPreset]
    @State private var showSaveSheet = false
    @State private var newPresetName = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Built-in Presets") {
                    ForEach(GridPreset.builtIn, id: \.name) { preset in
                        Button {
                            gridViewModel.applyPreset(preset)
                            dismiss()
                        } label: {
                            presetRow(preset)
                        }
                    }
                }

                if !presets.isEmpty {
                    Section("Custom Presets") {
                        ForEach(presets) { preset in
                            Button {
                                gridViewModel.applyPreset(preset)
                                dismiss()
                            } label: {
                                presetRow(preset)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    modelContext.delete(preset)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Grid Presets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showSaveSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Save Preset", isPresented: $showSaveSheet) {
                TextField("Preset Name", text: $newPresetName)
                Button("Save") {
                    if !newPresetName.isEmpty {
                        gridViewModel.createPreset(name: newPresetName, modelContext: modelContext)
                        newPresetName = ""
                    }
                }
                Button("Cancel", role: .cancel) {
                    newPresetName = ""
                }
            } message: {
                Text("Enter a name for the current grid configuration")
            }
        }
    }

    private func presetRow(_ preset: GridPreset) -> some View {
        HStack {
            Circle()
                .fill(preset.gridColor.swiftUIColor)
                .frame(width: 12, height: 12)
            VStack(alignment: .leading) {
                Text(preset.name)
                    .font(.subheadline.weight(.medium))
                Text("\(String(format: "%.2f", preset.gridSize))\(preset.unit.rawValue) · \(preset.gridColor.displayName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
