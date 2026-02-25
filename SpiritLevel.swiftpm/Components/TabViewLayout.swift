import SwiftUI

struct TabViewLayout<AppStateManagerType: AppStateManagable>: View {
    @Bindable var appStateManager: AppStateManagerType
    
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
                SearchView(appStateManager: appStateManager)
            }
        }
    }
}
