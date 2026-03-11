import SwiftUI

struct SearchHistoryView<AppStateManagerType: AppStateManageable>: View {
    private var searchHistoryManager: SearchHistoryManager<AppStateManagerType>
    @Binding private var searchText: String
    
    init(searchHistoryManager: SearchHistoryManager<AppStateManagerType>, searchText: Binding<String>) {
        self.searchHistoryManager = searchHistoryManager
        self._searchText = searchText
    }
    
    var body: some View {
        let isSearchHistoryEmpty = searchHistoryManager.searchHistory.isEmpty
        
        HStack {
            Text("Recent Searches")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                withAnimation {
                    searchHistoryManager.clearHistory()
                }
            }, label: {
                Text("Clear history")
            })
            .buttonStyle(.plain)
            .foregroundStyle(.accent)
            .disabled(isSearchHistoryEmpty)
        }
        .listRowSeparator(.hidden)
        
        if isSearchHistoryEmpty {
            Text(.emptyHistoryMessage)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            ForEach(searchHistoryManager.searchHistory.enumerated(), id: \.offset) { _, query in
                Button(action: {
                    withAnimation { searchText = query }
                }, label: {
                    Text(query)
                        .listRowBackground(Color.clear)
                })
            }
        }
    }
}

private extension LocalizedStringResource {
    static let emptyHistoryMessage: Self = "No search history yet"
}
