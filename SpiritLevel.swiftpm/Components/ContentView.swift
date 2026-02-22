import SwiftUI
import Charts

struct ContentView: View {
    @ObservedObject private var appState = AppStateManager.shared
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            ForEach(Array(AppArea.allCases.enumerated()), id: \.offset) { index, area in
                Tab(area.label,
                    systemImage: area.systemImageName,
                    value: index) {
                    NavigationView {
                        AnyView(area.tabView)
                    }
                }
            }
            Tab(.searchTitle, systemImage: .magnifyingglass, value: -1, role: .search) {
                SearchView()
            }
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
