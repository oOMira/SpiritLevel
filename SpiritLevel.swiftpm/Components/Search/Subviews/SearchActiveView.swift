import SwiftUI

struct SearchActiveView<SearchManagerType: SearchResultsManagable,
                        AppStateManagerType: AppStateManagable>: View {
    
    var searchHistoryManager: SearchHistoryViewManager<AppStateManagerType>
    @Bindable var searchManager: SearchManagerType
    
    // MARK: - Initializer
    
    init(appStateManager: AppStateManagerType,
         searchManager: SearchManagerType) {
        self.searchHistoryManager = .init(appStateManager: appStateManager)
        self.searchManager = searchManager
    }
    
    init(searchManager: SearchManagerType,
         searchHistoryManager: SearchHistoryViewManager<AppStateManagerType>) {
        self.searchHistoryManager = searchHistoryManager
        self.searchManager = searchManager
    }
    
    // MARK: - View

    var body: some View {
        if searchManager.searchText.isEmpty {
            if searchHistoryManager.searchHistory.isEmpty {
                NoSearchHistoryCell()
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 32)
            } else {
                SearchHistoryView(searchHistoryManager: searchHistoryManager,
                                  searchText: $searchManager.searchText)
            }
        } else {
            if searchManager.filteredItems.isEmpty {
                EmptySearchResultsView()
                    .listRowSeparator(.hidden)
            } else {
                ForEach(searchManager.filteredItems, id: \.id) { item in
                    NavigationLink(destination: {
                        item.configuration.getDestination()
                    }, label: {
                        SearchResultCellView(label: item.label, image: item.image)
                    })
                }
            }
        }
    }
}
