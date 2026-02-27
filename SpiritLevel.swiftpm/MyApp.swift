import SwiftUI
import SwiftData

@main
struct MyApp: App {
    let appStartRepository: AppStartRepository
    let appStateRepository: AppStateRepository
    let injectionRepository: InjectionRepository
    let searchResultsManager: SearchResultsManager
    
    let modelContainer: ModelContainer
    let modelContex: ModelContext
    
    init() {
        appStartRepository = AppStartRepository.shared
        appStateRepository = AppStateRepository.shared
        
        modelContainer = try! ModelContainer(for: Injection.self)
        modelContex = modelContainer.mainContext

        injectionRepository = InjectionRepository(modelContext: modelContex)
        
        let defaultItems = SearchResultsManager.getDefaultItems(appStateManager: appStateRepository,
                                                                injectionRepository: injectionRepository)
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
            ContentView(appStateManager: appStateRepository,
                        searchResultsManager: searchResultsManager,
                        injectionRepository: injectionRepository)
        }
    }
}
