import SwiftUI

struct SearchActiveView<SearchManagerType: SearchResultsManageable,
                        AppStateManagerType: AppStateManageable>: View {

    var searchHistoryManager: SearchHistoryManager<AppStateManagerType>
    @Bindable var searchManager: SearchManagerType
    
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
                    NavigationLink(value: item) {
                        SearchResultCellView(label: item.label, image: item.image)
                    }
                }
            }
        }
    }
}
