import SwiftUI

struct TabViewLayout<AppStateManagerType: AppStateManagable,
                     SearchResultsManagerType: SearchResultsManagable,
                     InjectionReposetoryType: InjectionManagable>: View {
    
    @Bindable private var appStateManager: AppStateManagerType
    private var searchResultsManager: SearchResultsManagerType
    private var injectionReposetory: InjectionReposetoryType
    
    init(appStateManager: AppStateManagerType,
         searchResultsManager: SearchResultsManagerType,
         injectionReposetory: InjectionReposetoryType) {
        self.appStateManager = appStateManager
        self.searchResultsManager = searchResultsManager
        self.injectionReposetory = injectionReposetory
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
                        case .overview: Overview(appStateManager: appStateManager,
                                                 injectionRepository: injectionReposetory)
                        case .statisitcs: StatisticsView()
                        case .settings: SettingsView()
                        }
                    }
                }
            }
            Tab(.searchTitle, systemImage: .magnifyingglass, value: -1, role: .search) {
                SearchView(appStateManager: appStateManager,
                           searchResultsManager: searchResultsManager,
                           injectionReposetory: injectionReposetory)
            }
        }
    }
}

