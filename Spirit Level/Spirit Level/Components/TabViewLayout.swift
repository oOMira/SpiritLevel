import SwiftUI

struct TabViewLayout<DependenciesType: AppDependenciesProtocol, SearchManagerType: SearchResultsManageable>: View {
    
    @Bindable var dependencies: DependenciesType
    var searchResultsManager: SearchManagerType
    
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
                        case .statistics: StatisticsView(dependencies: dependencies)
                        case .settings: SettingsView(dependencies: dependencies)
                        }
                    }
                }
            }
            Tab(.searchTitle, systemImage: .magnifyingglass, value: -1, role: .search) {
                SearchView(dependencies: dependencies, searchManager: searchResultsManager)
            }
        }
    }
}
