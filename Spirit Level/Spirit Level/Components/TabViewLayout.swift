import SwiftUI

struct TabViewLayout<DependenciesType: AppDependenciesProtocol>: View {
    
    @Bindable var dependencies: DependenciesType
    
    var body: some View {
        TabView(selection: $dependencies.appStateManager.selectedTab) {
            let enumeratedAppAreas = Array(AppArea.allCases.enumerated())
            ForEach(enumeratedAppAreas, id: \.offset) { index, area in
                Tab(area.label,
                    systemImage: area.systemImageName,
                    value: index) {
                    NavigationStack {
                        switch area {
                        case .overview: Overview(dependencies: dependencies)
                        case .statistics: StatisticsView(injectionRepository: dependencies.injectionRepository,
                                                         labResultsRepository: dependencies.labResultsRepository,
                                                         hormoneLevelManager: dependencies.hormoneLevelManager)
                        case .settings: SettingsView(appStartRepository: dependencies.appStartRepository,
                                                     appStateRepository: dependencies.appStateManager,
                                                     injectionRepository: dependencies.injectionRepository,
                                                     labResultsRepository: dependencies.labResultsRepository,
                                                     treatmentPlanRepository: dependencies.treatmentPlanRepository,
                                                     hormoneLevelManager: dependencies.hormoneLevelManager)
                        }
                    }
                }
            }
            Tab(.searchTitle, systemImage: .magnifyingglass, value: -1, role: .search) {
                SearchView(dependencies: dependencies)
            }
        }
    }
}
