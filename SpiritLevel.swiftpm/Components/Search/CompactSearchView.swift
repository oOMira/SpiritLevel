import SwiftUI

struct CompactSearchView: View {
    @ObservedObject var viewModel = SearchHistoryViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        List {
            SearchActiveView(searchText: $searchText)
        }
        .listStyle(.plain)
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("search")
        )
    }
}
