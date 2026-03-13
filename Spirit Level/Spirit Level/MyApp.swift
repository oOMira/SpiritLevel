import SwiftUI
import SwiftData
import Combine

class AppData: ObservableObject {
    @Published var appStartDate: Date = Date()
    
    func refresh() {
        appStartDate = Date()
    }
}

@main
struct MyApp: App {
    @StateObject private var appData = AppData()
    @Environment(\.scenePhase) private var scenePhase
    
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
                                     appStartManger: appStartRepository,
                                     injectionRepository: injectionRepository,
                                     treatmentPlanRepository: treatmentPlanRepository,
                                     hormoneLevelManager: hormoneLevelManager,
                                     labResultsRepository: labResultsRepository)
    }
    
    static func logFirstAppStart(in repository: AppStartManageable) {
        guard repository.firstAppStart == nil else { return }
        let date = Date()
        repository.firstAppStart = date
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: appDependencies,
                        searchResultsManager: searchResultsManager)
            .environmentObject(appData)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            guard oldPhase != newPhase, newPhase == .active else { return }
            appData.refresh()
        }
    }
}
