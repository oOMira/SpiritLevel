import SwiftUI

struct CompactSearchView<AppStateManagerType: AppStateManagable,
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
    
    var body: some View {
        List {
            SearchActiveView(appStateManager: appStateManager,
                             searchManager: searchResultsManager)
        }
        .listStyle(.plain)
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .searchable(
            text: $searchResultsManager.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("search")
        )
    }
}
