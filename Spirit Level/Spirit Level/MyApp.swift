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
                                         SearchResultsManager,
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
        
        let defaultItems = SearchResultsManager.getDefaultItems(
            appStateManager: appStateRepository,
            appStartRepository: appStartRepository,
            injectionRepository: injectionRepository,
            labResultsRepository: labResultsRepository,
            treatmentPlanRepository: treatmentPlanRepository,
            hormoneManager: hormoneLevelManager
        )
        self.searchResultsManager = SearchResultsManager(items: defaultItems)
        Self.logFirstAppStart(in: appStartRepository)
        self.appDependencies = .init(appStateManager: appStateRepository,
                                     appStartRepository: appStartRepository,
                                     searchResultsManager: searchResultsManager,
                                     injectionRepository: injectionRepository,
                                     labResultsRepository: labResultsRepository,
                                     treatmentPlanRepository: treatmentPlanRepository,
                                     hormoneLevelManager: hormoneLevelManager)
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
