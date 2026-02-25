import SwiftUI

struct SearchView<AppStateManagerType: AppStateManagable,
                  SearchResultsManagerType: SearchResultsManagable>: View {
    
    private var appStateManager: AppStateManagerType
    private var searchHistoryManager: SearchHistoryViewManager<AppStateManagerType>
    @Bindable private var searchResultsManager: SearchResultsManagerType
    
    init(appStateManager: AppStateManagerType,
         searchHistoryManager: SearchHistoryViewManager<AppStateManagerType>,
         searchResultsManager: SearchResultsManagerType) {
        self.appStateManager = appStateManager
        self.searchHistoryManager = searchHistoryManager
        self.searchResultsManager = searchResultsManager
    }
    
    init(appStateManager: AppStateManagerType,
         searchResultsManager: SearchResultsManagerType) {
        self.appStateManager = appStateManager
        self.searchHistoryManager = .init(appStateManager: appStateManager)
        self.searchResultsManager = searchResultsManager
    }
    
    @State private var activeSheet: ShortcutFeature?
    @State private var isSearching: Bool = false

    var body: some View {
        NavigationView {
            List {
                if isSearching {
                    SearchActiveView(searchManager: searchResultsManager,
                                     searchHistoryManager: searchHistoryManager)
                } else {
                    SearchInactiveView(activeSheet: $activeSheet,
                                       appStateManager: appStateManager,
                                       navigationItems: AppArea.allCases,
                                       actionItems: ShortcutFeature.allCases)
                }
            }
            .animation(.snappy, value: searchResultsManager.searchText)
            .animation(.snappy, value: searchHistoryManager.searchHistory.isEmpty)
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
                searchHistoryManager.addToHistory(searchResultsManager.searchText)
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
