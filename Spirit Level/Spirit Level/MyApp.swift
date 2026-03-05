import SwiftUI
import SwiftData
import Combine

// Repository logic is written and executed by me. Boiler plate is AI generated.
// Environment var is AI generated and just cleaned up by me
// Some bug fixes are done by AI. This is mostly protocol conformance
// (Hashable and Identifiable are not the same even after working on a feature for too long)
// or being tired and having stored an object in a function resulting in recreations and bugs.
// unfortunately probably also because I'm new to "agentic coding" even more were introduced by AI
// Linting is done by AI. Spelling and grammar checking is done by AI
// Prototyping is done with AI. Every view was replaced or needed heavy refactoring.
// Brainstorming for accessibility was done with AI (since a lot of stuff does not work the UIKit way anymore)
// Things like SFSymbol mapping and image description generation are drafted by AI and just fine tuned
// The achievement images are generated in Image Playground and desperately need some Pixelmator love
// Implementation of Brent's method is AI generated.
// The areas are also marked at the matching code section.

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
            .tint(.pink)
            .environmentObject(appData)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            guard oldPhase != newPhase, newPhase == .active else { return }
            appData.refresh()
        }
    }
}
