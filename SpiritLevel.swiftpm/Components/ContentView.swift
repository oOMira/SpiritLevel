import SwiftUI
import Charts

struct ContentView: View {
    @ObservedObject private var appState = AppStateManager.shared
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            let enumaratedAppAreas = Array(AppArea.allCases.enumerated())
            ForEach(enumaratedAppAreas, id: \.offset) { index, area in
                Tab(area.label,
                    systemImage: area.systemImageName,
                    value: index) {
                    NavigationView {
                        innerViewForAppArea(area)
                    }
                }
            }
            Tab(.searchTitle, systemImage: .magnifyingglass, value: -1, role: .search) {
                SearchView()
            }
        }
    }
    
    @ViewBuilder
    private func innerViewForAppArea(_ area: AppArea) -> some View {
        switch area {
        case .overview: Overview()
        case .statisitcs: StatisticsView()
        case .settings: SettingsView()
        }
    }
}

// MARK: - Constants

@MainActor
extension LocalizedStringKey {
    static let searchTitle: Self = "Search"
}

extension String {
    static let magnifyingglass: Self = "magnifyingglass"
}

