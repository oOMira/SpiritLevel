import SwiftUI

struct SearchView<AppStateManagerType: AppStateManagable>: View {
    var appStateManager: AppStateManagerType
    
    @State private var activeSheet: ShortcutFeature?
    @State private var isSearching: Bool = false
    @State var searchResultsManager = SearchResultsManager()

    private var searchHistory: [String] {
        (try? JSONDecoder().decode([String].self, from: Data(appStateManager.searchHistoryData.utf8))) ?? []
    }

    private func addToHistory(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        var history = searchHistory
        history.removeAll { $0 == trimmed }
        history.insert(trimmed, at: 0)
        history = Array(history.prefix(Int.maxHistoryItems))
        if let data = try? JSONEncoder().encode(history) {
            appStateManager.searchHistoryData = String(data: data, encoding: .utf8) ?? "[]"
        }
    }

    private func clearHistory() {
        appStateManager.searchHistoryData = "[]"
    }

    var body: some View {
        NavigationView {
            List {
                if isSearching {
                    SearchActiveView(searchManager: searchResultsManager)
                } else {
                    SearchInactiveView(activeSheet: $activeSheet,
                                       navigationItems: AppArea.allCases,
                                       actionItems: ShortcutFeature.allCases)
                }
            }
            .animation(.snappy, value: searchResultsManager.searchText)
            .animation(.snappy, value: searchHistory.isEmpty)
            .listStyle(.plain)
            .navigationTitle(.navigationTitle)
            .searchable(
                text: $searchResultsManager.searchText,
                isPresented: $isSearching,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text(.searchPrompt)
            )
            .autocorrectionDisabled(true)
            .onSubmit(of: .search) {
                addToHistory(searchResultsManager.searchText)
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .logInjection:
                    LogInjectionView()
                        .presentationDetents([.medium, .large])
                case .logLab:
                    LogLabView()
                        .presentationDetents([.medium, .large])
                }
            }
        }
    }
}

// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let navigationTitle: Self = "Search"
    static let searchPrompt: Self = "Search"
    static let recentSearchesTitle: Self = "Recent Searches"
    static let clearHistoryButton: Self = "Clear history"
}

private extension Int {
    static let maxHistoryItems: Self = 10
}
