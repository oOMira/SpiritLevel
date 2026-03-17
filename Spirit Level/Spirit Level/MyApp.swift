import SwiftUI
import SwiftData

@Observable
class AppData {
    var appStartDate: Date = Date()
    
    func refresh() {
        appStartDate = Date()
    }
}

@main
struct MyApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var appData = AppData()
    
    let appDependencies: AppDependencies<AppStateRepository,
                                         AppStartRepository,
                                         InjectionRepository,
                                         LabResultsRepository,
                                         TreatmentPlanRepository,
                                         HormoneLevelManager>
    
    let searchResultsManager: SearchResultsManager
    let modelContainer: ModelContainer
    
    init() {
        let appStartRepository = AppStartRepository.shared
        let appStateRepository = AppStateRepository.shared
        
        let config = ModelConfiguration()
        
        // TODO: - Handle Error UI
        modelContainer = try! ModelContainer(for: Injection.self, LabResult.self, TreatmentPlan.self, configurations: config)
        
        let injectionRepository = InjectionRepository(modelContext: modelContainer.mainContext)
        let labResultsRepository = LabResultsRepository(modelContext: modelContainer.mainContext)
        let treatmentPlanRepository = TreatmentPlanRepository(modelContext: modelContainer.mainContext)
        
        let hormoneLevelManager: HormoneLevelManager = .init()
        
        Self.logFirstAppStart(in: appStartRepository)
        let appDependencies = AppDependencies(appStateManager: appStateRepository,
                                              appStartRepository: appStartRepository,
                                              injectionRepository: injectionRepository,
                                              labResultsRepository: labResultsRepository,
                                              treatmentPlanRepository: treatmentPlanRepository,
                                              hormoneLevelManager: hormoneLevelManager)
        let defaultItems = SearchResultsManager.getDefaultItems(dependencies: appDependencies)
        self.searchResultsManager = SearchResultsManager(items: defaultItems)
        self.appDependencies = appDependencies
    }
    
    static func logFirstAppStart(in repository: AppStartManageable) {
        guard repository.firstAppStart == nil else { return }
        repository.firstAppStart = .init().start
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: appDependencies)
                .environment(appData)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            guard oldPhase != newPhase, newPhase == .active else { return }
            appData.refresh()
        }
    }
}
