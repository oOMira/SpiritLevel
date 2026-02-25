import SwiftUI

struct SearchActiveView<SearchManagerType: SearchResultsManagable>: View {
    @ObservedObject var viewModel = SearchHistoryViewModel()
    var searchManager: SearchManagerType
    
    var body: some View {
        if searchManager.searchText.isEmpty {
            if viewModel.searchHistory.isEmpty {
                NoSearchHistoryCell()
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 32)
            } else {
                SearchHistoryView(searchHistory: viewModel.searchHistory,
                                  clearHistory: viewModel.clearHistory)
            }
        } else {
            if searchManager.filteredItems.isEmpty {
                EmptySearchResultsView()
                    .listRowSeparator(.hidden)
            } else {
                ForEach(searchManager.filteredItems, id: \.id) { item in
                    NavigationLink(destination: {
                        List {
                            Text(item.label)
                        }
                        .navigationTitle(item.label)
                    }, label: {
                        SearchResultCellView(label: item.label, image: item.image)
                    })
                }
            }
        }
    }
}
