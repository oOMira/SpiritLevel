import SwiftUI

@main
struct MyApp: App {
    var appStateManager = AppStateManager.shared
    var searchResultsManager = SearchResultsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(appStateManager: appStateManager, searchResultsManager: searchResultsManager)
        }
    }
}
