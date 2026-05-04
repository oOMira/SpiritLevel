import SwiftUI

typealias CompactSearchDependencies = HasAppStateManager

struct CompactSearchView<Dependencies: CompactSearchDependencies,
                         SearchResultsMgr: SearchResultsManageable>: View {

    @State private var path = NavigationPath()

    let dependencies: Dependencies

    let searchHistoryManager: SearchHistoryManager<Dependencies.AppStateMgr>
    let searchResultsManager: SearchResultsMgr

    init(dependencies: Dependencies, searchResultsManager: SearchResultsMgr) {
        self.dependencies = dependencies
        self.searchHistoryManager = .init(appStateManager: dependencies.appStateManager)
        self.searchResultsManager = searchResultsManager
    }

    var body: some View {
        NavigationStack(path: $path) {
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
                prompt: Text("Search")
            )
            .onSubmit(of: .search) {
                searchHistoryManager.addToHistory(searchResultsManager.searchText)
            }
            .selectedSearchItemDestination()
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    let deps = Mocks.appDependencies
    let searchManager = SearchResultsManager(items: SearchResultsManager.getDefaultItems(dependencies: deps))
    CompactSearchView(dependencies: deps, searchResultsManager: searchManager)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let deps = Mocks.appDependencies
    let searchManager = SearchResultsManager(items: SearchResultsManager.getDefaultItems(dependencies: deps))
    CompactSearchView(dependencies: deps, searchResultsManager: searchManager)
        .preferredColorScheme(.dark)
}
