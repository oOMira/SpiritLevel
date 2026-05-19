import SwiftUI
import SwiftData
import SpiritLevelShared

@main
struct SpiritLevelWatchApp: App {
    private let modelContainer: ModelContainer
    @State private var connectivityManager: WatchConnectivityManager

    init() {
        do {
            let container = try SharedModelContainer.create()
            modelContainer = container
            _connectivityManager = State(
                initialValue: WatchConnectivityManager(modelContext: container.mainContext)
            )
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
