import SwiftUI
import Charts

struct ContentView: View {
    @AppStorage("selectedTab") private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Array(AppArea.allCases.enumerated()), id: \.offset) { index, area in
                Tab(area.label,
                    systemImage: area.systemImageName,
                    value: index) {
                    AnyView(area.tabView)
                }
            }
            Tab(.searchTitle, systemImage: .magnifyingglass, value: -1, role: .search) {
                SearchView()
            }
        }
    }
}

// MARK: - AppArea+View

private extension AppArea {
    var tabView: any View {
        switch self {
        case .overview:
            return Overview()
        case .statisitcs:
            return StatisticsView()
        case .settings:
            return SettingsView()
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
