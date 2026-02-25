import SwiftUI

@main
struct MyApp: App {
    var appStateManager = AppStateManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView(appStateManager: appStateManager)
        }
    }
}
