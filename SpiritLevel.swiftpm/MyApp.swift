import SwiftUI

@main
struct MyApp: App {
    var appStateManager: AppStateManager
    var searchResultsManager: SearchResultsManager
    
    init() {
        appStateManager = AppStateManager.shared
        let defaultItems = SearchResultsManager.getDefaultItems(appStateManager: appStateManager)
        searchResultsManager = SearchResultsManager(items: defaultItems)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(appStateManager: appStateManager, searchResultsManager: searchResultsManager)
        }
    }
}
