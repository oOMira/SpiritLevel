import SwiftUI

struct SearchHistoryView<AppStateManagerType: AppStateManagable>: View {
    private var searchHistoryManager: SearchHistoryViewManager<AppStateManagerType>
    @Binding private var searchText: String
    
    init(searchHistoryManager: SearchHistoryViewManager<AppStateManagerType>, searchText: Binding<String>) {
        self.searchHistoryManager = searchHistoryManager
        self._searchText = searchText
    }
    
    var body: some View {
        // MARK: - Header
        
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
                    .font(.footnote.bold())
                    .foregroundStyle(.red)
            })
        }
        .listRowSeparator(.hidden)
        
        // MARK: - Search History
        
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
