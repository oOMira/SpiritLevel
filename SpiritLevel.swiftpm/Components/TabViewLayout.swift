import SwiftUI

struct TabViewLayout: View {
    @ObservedObject private var appState = AppStateManager.shared
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            let enumaratedAppAreas = Array(AppArea.allCases.enumerated())
            ForEach(enumaratedAppAreas, id: \.offset) { index, area in
                Tab(area.label,
                    systemImage: area.systemImageName,
                    value: index) {
                    NavigationView {
                        switch area {
                        case .overview: Overview()
                        case .statisitcs: StatisticsView()
                        case .settings: SettingsView()
                        }
                    }
                }
            }
            Tab(.searchTitle, systemImage: .magnifyingglass, value: -1, role: .search) {
                SearchView()
            }
        }
    }
}
