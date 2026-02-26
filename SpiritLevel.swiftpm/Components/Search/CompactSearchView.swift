import SwiftUI

struct CompactSearchView<AppStateManagerType: AppStateManagable,
                         SearchResultsManagerType: SearchResultsManagable>: View {
    
    @State private var navigationManager = NavigationManager()
    
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
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            List {
                SearchActiveView(appStateManager: appStateManager,
                                 searchManager: searchResultsManager)
            }
            .animation(.snappy, value: searchResultsManager.searchText)
            .animation(.snappy, value: searchHistoryManager.searchHistory.isEmpty)
            .listStyle(.plain)
            .autocorrectionDisabled(true)
            .searchable(
                text: $searchResultsManager.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("search")
            )
            .onSubmit(of: .search) {
                searchHistoryManager.addToHistory(searchResultsManager.searchText)
            }
            .selectedSearchItemDestination()
        }
        .environment(navigationManager)
    }
}
