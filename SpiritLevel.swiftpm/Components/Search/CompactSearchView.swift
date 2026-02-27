import SwiftUI

struct CompactSearchView<AppStateManagerType: AppStateManageable,
                         SearchResultsManagerType: SearchResultsManageable>: View {
    
    @State private var navigationManager = NavigationManager()
    
    let appStateManager: AppStateManagerType
    let searchHistoryManager: SearchHistoryManager<AppStateManagerType>
    @Bindable var searchResultsManager: SearchResultsManagerType
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            List {
                SearchActiveView(searchHistoryManager: searchHistoryManager,
                                 searchManager: searchResultsManager)
            }
            .animation(.snappy, value: searchResultsManager.searchText)
            .animation(.snappy, value: searchHistoryManager.searchHistory.isEmpty)
            .animation(.snappy, value: searchResultsManager.filteredItems.isEmpty)
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
