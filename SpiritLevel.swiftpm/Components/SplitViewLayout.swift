import SwiftUI

struct SplitViewLayout: View {
    @ObservedObject private var appState = AppStateManager.shared
    @State private var isShowingListSheet = false
    
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
                    Button(action: {
                        isShowingListSheet = true
                    }, label: {
                        Text("Log Lab Results")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .tint(.primary)
                    .padding(.horizontal, 16)
                    Button(action: {
                        isShowingListSheet = true
                    }, label: {
                        Text("Log Injection")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .sheet(isPresented: $isShowingListSheet) {
                Text("Sheet")
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
