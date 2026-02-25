import SwiftUI

struct SplitViewLayout: View {
    @ObservedObject private var appState = AppStateManager.shared
    @State private var activeSheet: ShortcutFeature? = nil
    
    var body: some View {
        let enumaratedAppAreas = Array(AppArea.allCases.enumerated())
        NavigationSplitView {
            List(selection: $appState.selectedTab.toOptional()) {
                Label("Search", systemImage: "magnifyingglass")
                    .tag(-1)
                ForEach(enumaratedAppAreas, id: \.offset) { index, area in
                    Label(area.label, systemImage: area.systemImageName)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 8) {
                    ForEach(ShortcutFeature.allCases, id: \.id) { feature in
                        let button = Button(action: {
                            activeSheet = feature
                        }, label: {
                            Text(feature.label)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                        })
                        .buttonBorderShape(.roundedRectangle)
                        .tint(feature.buttonColor)
                        .padding(.horizontal, 16)
                        
                        switch feature {
                        case .logLab:
                            button.buttonStyle(.bordered)
                        case .logInjection:
                            button.buttonStyle(.borderedProminent)
                        }
                    }
                }
                .accessibilityElement(children: .contain)
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .logInjection: LogInjectionView()
                    .presentationDetents([.large])
                case .logLab: LogLabView()
                    .presentationDetents([.large])
                }
            }
        } detail: {
            NavigationStack {
                if appState.selectedTab == -1 {
                    CompactSearchView()
                } else {
                    let selectedAppArea = enumaratedAppAreas[appState.selectedTab].element
                    switch selectedAppArea {
                    case .overview:
                        CompactOverview()
                    case .statisitcs:
                        StatisticsView()
                    case .settings:
                        SettingsView()
                    }
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

private extension ShortcutFeature {
    var buttonColor: Color {
        switch self {
        case .logInjection: return .accentColor
        case .logLab: return .primary
        }
    }

}
