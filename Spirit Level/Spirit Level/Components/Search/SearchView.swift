import SwiftUI

struct SearchView<AppStateManagerType: AppStateManageable,
                  AppStartRepositoryType: AppStartManageable,
                  SearchResultsManagerType: SearchResultsManageable,
                  InjectionRepositoryType: InjectionManageable,
                  LabResultsRepositoryType: LabResultsManageable,
                  TreatmentPlanRepositoryType: TreatmentPlanManageable,
                  HormoneLevelManagerType: HormoneLevelManageable>: View {

    @State private var navManager = NavigationManager()
    
    let appStateManager: AppStateManagerType
    let appStartRepository: AppStartRepositoryType
    let searchHistoryManager: SearchHistoryManager<AppStateManagerType>
    let injectionRepository: InjectionRepositoryType
    let labResultsRepository: LabResultsRepositoryType
    let treatmentPlanRepository: TreatmentPlanRepositoryType
    let hormoneLevelManager: HormoneLevelManagerType
    let searchResultsManager: SearchResultsManagerType
    
    @State private var activeSheet: ShortcutFeature?
    @State private var isSearching: Bool = false

    var body: some View {
        NavigationStack(path: $navManager.path) {
            List {
                if isSearching {
                    SearchActiveView(searchHistoryManager: searchHistoryManager,
                                     searchManager: searchResultsManager)
                } else {
                    SearchInactiveView(activeSheet: $activeSheet,
                                       appStateManager: appStateManager,
                                       navigationItems: AppArea.allCases,
                                       actionItems: ShortcutFeature.allCases)
                }
            }
            .listStyle(.plain)
            .navigationTitle(.navigationTitle)
            .searchable(
                text: Binding(
                    get: { searchResultsManager.searchText },
                    set: { newValue in
                        withAnimation(.snappy) {
                            searchResultsManager.searchText = newValue
                        }
                    }
                ),
                isPresented: $isSearching,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text(.searchPrompt)
            )
            .autocorrectionDisabled(true)
            .onSubmit(of: .search) {
                searchHistoryManager.addToHistory(searchResultsManager.searchText)
            }
            .activeSheetDestination(activeSheet: $activeSheet,
                                    injectionRepository: injectionRepository,
                                    labResultsRepository: labResultsRepository)
            .navigationDestination(for: AppArea.self) { item in
                switch item {
                case .overview: Overview(appStateManager: appStateManager,
                                         appStartRepository: appStartRepository,
                                         injectionRepository: injectionRepository,
                                         labResultsRepository: labResultsRepository,
                                         treatmentPlanRepository: treatmentPlanRepository,
                                         hormoneManager: hormoneLevelManager)
                case .statistics: StatisticsView(injectionRepository: injectionRepository,
                                                 labResultsRepository: labResultsRepository,
                                                 hormoneLevelManager: hormoneLevelManager)
                case .settings: SettingsView(appStartRepository: appStartRepository,
                                             appStateRepository: appStateManager,
                                             injectionRepository: injectionRepository,
                                             labResultsRepository: labResultsRepository,
                                             treatmentPlanRepository: treatmentPlanRepository,
                                             hormoneLevelManager: hormoneLevelManager)
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
