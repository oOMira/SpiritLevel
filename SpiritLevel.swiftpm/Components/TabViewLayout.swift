import SwiftUI

struct TabViewLayout<AppStateManagerType: AppStateManagable,
                     SearchResultsManagerType: SearchResultsManagable>: View {
    
    @Bindable private var appStateManager: AppStateManagerType
    private var searchResultsManager: SearchResultsManagerType
    
    init(appStateManager: AppStateManagerType, searchResultsManager: SearchResultsManagerType) {
        self.appStateManager = appStateManager
        self.searchResultsManager = searchResultsManager
    }
    
    
    var body: some View {
        TabView(selection: $appStateManager.selectedTab) {
            let enumaratedAppAreas = Array(AppArea.allCases.enumerated())
            ForEach(enumaratedAppAreas, id: \.offset) { index, area in
                Tab(area.label,
                    systemImage: area.systemImageName,
                    value: index) {
                    NavigationView {
                        switch area {
                        case .overview: Overview(appStateManager: appStateManager)
                        case .statisitcs: StatisticsView()
                        case .settings: SettingsView()
                        }
                    }
                }
            }
            Tab(.searchTitle, systemImage: .magnifyingglass, value: -1, role: .search) {
                SearchView(appStateManager: appStateManager, searchResultsManager: searchResultsManager)
            }
        }
    }
}

