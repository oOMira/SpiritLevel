import SwiftUI

struct SearchActiveView<SearchManagerType: SearchResultsManageable,
                        AppStateManagerType: AppStateManageable>: View {

    var searchHistoryManager: SearchHistoryManager<AppStateManagerType>
    @Bindable var searchManager: SearchManagerType
    
    // MARK: - View

    var body: some View {
        if searchManager.searchText.isEmpty {
            SearchHistoryView(searchHistoryManager: searchHistoryManager,
                              searchText: $searchManager.searchText)
            .transition(.opacity)
        } else {
            if searchManager.filteredItems.isEmpty {
                ContentUnavailableView.search(text: searchManager.searchText)
                    .listRowSeparator(.hidden)
                    .transition(.opacity)
            } else {
                Group {
                    ForEach(searchManager.filteredItems, id: \.id) { item in
                        NavigationLink(value: item) {
                            SearchResultCellView(label: item.label, image: item.image)
                        }
                    }
                }
                .transition(.opacity)
            }
        }
    }
}
