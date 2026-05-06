import SwiftUI
import HealthDataLogging

struct SearchView<DependenciesType: AppDependenciesProtocol, SearchManagerType: SearchResultsManageable>: View {

    @State private var path = NavigationPath()

    let dependencies: DependenciesType
    var searchManager: SearchManagerType

    @State private var activeSheet: ShortcutFeature?
    @State private var isSearching: Bool = false

    var body: some View {
        NavigationStack(path: $path) {
            List {
                if isSearching {
                    SearchActiveView(searchHistoryManager: .init(appStateManager: dependencies.appStateManager),
                                     searchManager: searchManager)
                } else {
                    SearchInactiveView(path: $path,
                                       activeSheet: $activeSheet,
                                       appStateManager: dependencies.appStateManager,
                                       searchManager: searchManager,
                                       navigationItems: AppArea.allCases,
                                       actionItems: ShortcutFeature.allCases)
                }
            }
            .listStyle(.plain)
            .navigationTitle(.navigationTitle)
            .searchable(
                text: Binding(
                    get: { searchManager.searchText },
                    set: { newValue in
                        withAnimation(.snappy) {
                            searchManager.searchText = newValue
                        }
                    }
                ),
                isPresented: $isSearching,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text(.searchPrompt)
            )
            .autocorrectionDisabled(true)
            .onSubmit(of: .search) {
                SearchHistoryManager(appStateManager: dependencies.appStateManager)
                    .addToHistory(searchManager.searchText)
            }
            .quickActionsSheetDestination(activeSheet: $activeSheet,
                                          injectionRepository: dependencies.injectionRepository,
                                          labResultsRepository: dependencies.labResultsRepository)
            .navigationDestination(for: AppArea.self) { item in
                switch item {
                case .overview: Overview(dependencies: dependencies)
                case .statistics: StatisticsView(dependencies: dependencies)
                case .settings: SettingsView(dependencies: dependencies)
                }
            }
            .selectedSearchItemDestination()
        }
    }
}
// MARK: - Constants

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Search"
    static let searchPrompt: Self = "Search"
    static let recentSearchesTitle: Self = "Recent Searches"
    static let clearHistoryButton: Self = "Clear history"
}

private extension Int {
    static let maxHistoryItems: Self = 10
}
