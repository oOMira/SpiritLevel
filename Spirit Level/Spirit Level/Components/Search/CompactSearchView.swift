import SwiftUI

struct CompactSearchView<AppStateManagerType: AppStateManageable,
                         SearchResultsManagerType: SearchResultsManageable>: View {
    
    @State private var navigationManager = NavigationManager()
    
    let appStateManager: AppStateManagerType
    let searchHistoryManager: SearchHistoryManager<AppStateManagerType>
    let searchResultsManager: SearchResultsManagerType
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            List {
                SearchActiveView(searchHistoryManager: searchHistoryManager,
                                 searchManager: searchResultsManager)
            }
            .listStyle(.plain)
            .autocorrectionDisabled(true)
            .searchable(
                text: Binding(
                    get: { searchResultsManager.searchText },
                    set: { newValue in
                        withAnimation(.snappy) {
                            searchResultsManager.searchText = newValue
                        }
                    }
                ),
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
