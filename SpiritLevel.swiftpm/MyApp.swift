import SwiftUI

@main
struct MyApp: App {
    let appStartRepository: AppStartRepository
    let appStateRepository: AppStateRepository
    let searchResultsManager: SearchResultsManager
    
    init() {
        appStartRepository = AppStartRepository.shared
        appStateRepository = AppStateRepository.shared
        let defaultItems = SearchResultsManager.getDefaultItems(appStateManager: appStateRepository)
        searchResultsManager = SearchResultsManager(items: defaultItems)

        Self.logFirstAppStart(in: appStartRepository)
    }
    
    static func logFirstAppStart(in repository: AppStartManagable) {
        guard repository.firstAppStart == nil else { return }
        let date = Date()
        repository.firstAppStart = date
    }
        
    
    var body: some Scene {
        WindowGroup {
            ContentView(appStateManager: appStateRepository, searchResultsManager: searchResultsManager)
        }
    }
}
