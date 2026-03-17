import SwiftUI

typealias CompactSearchDependencies = HasAppStateManager

struct CompactSearchView<Dependencies: CompactSearchDependencies,
                         SearchResultsManagerType: SearchResultsManageable>: View {
    
    @State private var navigationManager = NavigationManager()
    
    let dependencies: Dependencies
    
    let searchHistoryManager: SearchHistoryManager<Dependencies.AppStateManagerType>
    let searchResultsManager: SearchResultsManagerType
    
    init(dependencies: Dependencies, searchResultsManager: SearchResultsManagerType) {
        self.dependencies = dependencies
        self.searchHistoryManager = .init(appStateManager: dependencies.appStateManager)
        self.searchResultsManager = searchResultsManager
    }
    
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
