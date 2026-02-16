import SwiftUI
import Charts

struct ContentView: View {
    @Binding var deepLinkTarget: (any SearchableItem)?

    var body: some View {
        TabView {
            ForEach(AppArea.allCases) { area in
                Tab(area.label,
                    systemImage: area.systemImageName,
                    content: { AnyView(area.tabView) })
            }
            Tab(.searchTitle, systemImage: .magnifyingglass, role: .search) {
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

