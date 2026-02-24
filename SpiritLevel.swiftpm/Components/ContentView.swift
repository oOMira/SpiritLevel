import SwiftUI
import Charts

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject private var appState = AppStateManager.shared
    
    var body: some View {
        if horizontalSizeClass == .compact {
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
        } else {
            SplitViewLayout()
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

struct SplitViewLayout: View {
    @ObservedObject private var appState = AppStateManager.shared

    var body: some View {
        let enumaratedAppAreas = Array(AppArea.allCases.enumerated())
        NavigationSplitView {
            List(selection: $appState.selectedTab.toOptional()) {
                ForEach(enumaratedAppAreas, id: \.offset) { index, area in
                    Label(area.label, systemImage: area.systemImageName)
                }
            }
        } detail: {
            let selectedAppArea = enumaratedAppAreas[appState.selectedTab].element
            NavigationStack {
                switch selectedAppArea {
                case .overview:
                    Overview()
                case .statisitcs:
                    StatisticsView()
                case .settings:
                    SettingsView()
                }
            }
        }
    }
}

// MARK: - Helper

private extension Binding where Value == Int {
    func toOptional() -> Binding<Value?> {
        Binding<Value?>(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 ?? 0 }
        )
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

