import SwiftUI
import SwiftData

@main
struct GridLensApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: GridPreset.self)
    }
}
