import SwiftUI

struct SearchActiveView: View {
    @Binding var searchText: String
    @ObservedObject var viewModel = SearchHistoryViewModel()
    
    var body: some View {
        if searchText.isEmpty {
            if viewModel.searchHistory.isEmpty {
                NoSearchHistoryCell()
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 32)
            } else {
                SearchHistoryView(searchHistory: viewModel.searchHistory,
                                  clearHistory: viewModel.clearHistory)
            }
        } else {
            if filteredItems.isEmpty {
                EmptySearchResultsView()
                    .listRowSeparator(.hidden)
            } else {
                ForEach(filteredItems, id: \.id) { item in
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
    
    var filteredItems: [any SearchableItem] {
        let allItems = Content.allItems
        guard !searchText.isEmpty else { return allItems }

        return allItems.filter {
            $0.label.localizedCaseInsensitiveContains(searchText)
        }
    }
}
