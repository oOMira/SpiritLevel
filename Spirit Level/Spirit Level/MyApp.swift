import SwiftUI
import SwiftData
import OSLog

@Observable
class AppData {
    var appStartDate: Date = Date()

    func refresh() {
        appStartDate = Date.now
    }
}

@main
struct MyApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State var appData = AppData()
    @State var navigationManager = NavigationCoordinator.shared

    private let startupResult: AppStartupResult

    init() {
        startupResult = Self.makeStartupResult()
    }

    private static func makeStartupResult() -> AppStartupResult {
        let appStartRepository = AppStartRepository.shared
        let appStateRepository = AppStateRepository.shared
        let config = ModelConfiguration()

        do {
            let modelContainer = try ModelContainer(
                for: Injection.self,
                LabResult.self,
                TreatmentPlan.self,
                configurations: config
            )

            let injectionRepository = InjectionRepository(modelContext: modelContainer.mainContext)
            let labResultsRepository = LabResultsRepository(modelContext: modelContainer.mainContext)
            let treatmentPlanRepository = TreatmentPlanRepository(modelContext: modelContainer.mainContext)
            let hormoneLevelManager: HormoneLevelManager = .init()

            logFirstAppStart(in: appStartRepository)

            let appDependencies = AppDependencies(
                appStateManager: appStateRepository,
                appStartRepository: appStartRepository,
                injectionRepository: injectionRepository,
                labResultsRepository: labResultsRepository,
                treatmentPlanRepository: treatmentPlanRepository,
                hormoneLevelManager: hormoneLevelManager
            )

            let defaultItems = SearchResultsManager.getDefaultItems(dependencies: appDependencies)
            let searchResultsManager = SearchResultsManager(items: defaultItems)

            Logger.app.info("App startup completed successfully")

            return .success(
                AppStartupContext(
                    appDependencies: appDependencies,
                    searchResultsManager: searchResultsManager,
                    modelContainer: modelContainer
                )
            )
        } catch {
            Logger.app.error("App startup failed: \(error)")
            return .failure(error)
        }
    }

    static func logFirstAppStart(in repository: AppStartManageable) {
        guard repository.firstAppStart == nil else { return }
        repository.firstAppStart = .init().start
        Logger.app.info("Recorded first app start")
    }

    var body: some Scene {
        WindowGroup {
            switch startupResult {
            case let .success(context):
                ContentView(dependencies: context.appDependencies)
                    .environment(appData)
                    .quickActionsSheetDestination(
                        activeSheet: $navigationManager.activeQuickAction,
                        injectionRepository: context.appDependencies.injectionRepository,
                        labResultsRepository: context.appDependencies.labResultsRepository
                    )
                    .onOpenURL { url in
                        navigationManager.handle(url, appStateRepository: context.appDependencies.appStateManager)
                    }
            case let .failure(error):
                AppLaunchErrorView(error: error)
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            guard oldPhase != newPhase, newPhase == .active else { return }
            if case .success = startupResult {
                appData.refresh()
            }
        }
    }
}

private typealias AppStartupResult = Result<AppStartupContext, Error>

private struct AppStartupContext {
    let appDependencies: AppDependencies<
        AppStateRepository,
        AppStartRepository,
        InjectionRepository,
        LabResultsRepository,
        TreatmentPlanRepository,
        HormoneLevelManager
    >
    let searchResultsManager: SearchResultsManager
    let modelContainer: ModelContainer
}

private struct AppLaunchErrorView: View {
    let error: Error

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 36))
                .foregroundStyle(.yellow)

            Text("Unable to Start App")
                .font(.title3.bold())

            Text("Couldn’t load data. Please restart the app.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Text(error.localizedDescription)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
        .padding(24)
    }
}
