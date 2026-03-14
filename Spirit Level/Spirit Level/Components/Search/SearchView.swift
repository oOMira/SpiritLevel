import SwiftUI

struct SearchView<DependenciesType: AppDependenciesProtocol>: View {

    @State private var navManager = NavigationManager()
    
    let dependencies: DependenciesType
    
    @State private var activeSheet: ShortcutFeature?
    @State private var isSearching: Bool = false

    var body: some View {
        NavigationStack(path: $navManager.path) {
            List {
                if isSearching {
                    SearchActiveView(searchHistoryManager: .init(appStateManager: dependencies.appStateManager), searchManager: dependencies.searchResultsManager)
                } else {
                    SearchInactiveView(activeSheet: $activeSheet,
                                       appStateManager: dependencies.appStateManager,
                                       navigationItems: AppArea.allCases,
                                       actionItems: ShortcutFeature.allCases)
                }
            }
            .listStyle(.plain)
            .navigationTitle(.navigationTitle)
            .searchable(
                text: Binding(
                    get: { dependencies.searchResultsManager.searchText },
                    set: { newValue in
                        withAnimation(.snappy) {
                            dependencies.searchResultsManager.searchText = newValue
                        }
                    }
                ),
                isPresented: $isSearching,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text(.searchPrompt)
            )
            .autocorrectionDisabled(true)
            .onSubmit(of: .search) {
                SearchHistoryManager(appStateManager: dependencies.appStateManager).addToHistory(dependencies.searchResultsManager.searchText)
            }
            .activeSheetDestination(activeSheet: $activeSheet,
                                    injectionRepository: dependencies.injectionRepository,
                                    labResultsRepository: dependencies.labResultsRepository)
            .navigationDestination(for: AppArea.self) { item in
                switch item {
                case .overview: Overview(dependencies: dependencies)
                case .statistics: StatisticsView(injectionRepository: dependencies.injectionRepository,
                                                 labResultsRepository: dependencies.labResultsRepository,
                                                 hormoneLevelManager: dependencies.hormoneLevelManager)
                case .settings: SettingsView(appStartRepository: dependencies.appStartRepository,
                                             appStateRepository: dependencies.appStateManager,
                                             injectionRepository: dependencies.injectionRepository,
                                             labResultsRepository: dependencies.labResultsRepository,
                                             treatmentPlanRepository: dependencies.treatmentPlanRepository,
                                             hormoneLevelManager: dependencies.hormoneLevelManager)
                }
            }
            .selectedSearchItemDestination()
        }
        .environment(navManager)
    }
}

// MARK: - View Modifier

private extension View {
    func activeSheetDestination<T: InjectionManageable, U: LabResultsManageable>(
        activeSheet: Binding<ShortcutFeature?>, 
        injectionRepository: T,
        labResultsRepository: U
    ) -> some View {
        modifier(SearchInactiveViewModifier.SearchActiveActionsModifier(
            injectionRepository: injectionRepository,
            labResultsRepository: labResultsRepository,
            activeSheet: activeSheet))
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
