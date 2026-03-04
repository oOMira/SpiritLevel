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
    
    let injectionRepository: InjectionRepository
    let labResultsRepository: LabResultsRepository
    let treatmentPlanRepository: TreatmentPlanRepository
    let searchResultsManager: SearchResultsManager
    let appStartRepository: AppStartRepository
    let appStateRepository: AppStateRepository
    let modelContainer: ModelContainer
    let hormoneLevelManager: HormoneLevelManager
    
    init() {
        appStartRepository = AppStartRepository.shared
        appStateRepository = AppStateRepository.shared
        
        let config = ModelConfiguration()
        
        // TODO: - Handle Error UI
        modelContainer = try! ModelContainer(for: Injection.self, LabResult.self, TreatmentPlan.self, configurations: config)
        
        injectionRepository = InjectionRepository(modelContext: modelContainer.mainContext)
        labResultsRepository = LabResultsRepository(modelContext: modelContainer.mainContext)
        treatmentPlanRepository = TreatmentPlanRepository(modelContext: modelContainer.mainContext)
        
        hormoneLevelManager = .init()
        
        let defaultItems = SearchResultsManager.getDefaultItems(
            appStateManager: appStateRepository,
            appStartRepository: appStartRepository,
            injectionRepository: injectionRepository,
            labResultsRepository: labResultsRepository,
            treatmentPlanRepository: treatmentPlanRepository,
            hormoneManager: hormoneLevelManager
        )
        searchResultsManager = SearchResultsManager(items: defaultItems)
        Self.logFirstAppStart(in: appStartRepository)
    }
    
    static func logFirstAppStart(in repository: AppStartManageable) {
        guard repository.firstAppStart == nil else { return }
        let date = Date()
        repository.firstAppStart = date
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                appStateManager: appStateRepository,
                appStartRepository: appStartRepository,
                searchResultsManager: searchResultsManager,
                injectionRepository: injectionRepository,
                labResultsRepository: labResultsRepository,
                treatmentPlanRepository: treatmentPlanRepository,
                hormoneLevelManager: hormoneLevelManager
            )
            .environmentObject(appData)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            guard oldPhase != newPhase, newPhase == .active else { return }
            appData.refresh()
        }
    }
}
