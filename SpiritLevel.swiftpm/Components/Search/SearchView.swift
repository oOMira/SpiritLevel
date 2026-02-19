import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false

    var body: some View {
        NavigationView {
            List {
                if isSearching {
                    if searchText.isEmpty {
                        NoSearchHistoryCell()
                            .listRowSeparator(.hidden)
                    } else {
                        if filteredItems.isEmpty {
                            EmptySearchResultsView()
                                .listRowSeparator(.hidden)
                        } else {
                            ForEach(filteredItems, id: \.id) { item in
                                NavigationLink(destination: {
                                    Text("new")
                                }, label: {
                                    SearchResultCellView(label: item.label, image: item.image)
                                })
                            }
                        }
                    }
                } else {
                    SearchInactiveView(navigationItems: AppArea.allCases,
                                       actionItems: ShortcutFeature.allCases,
                                       allItems: Content.allItems)
                }
            }
            .animation(.snappy, value: searchText)
            .listStyle(.plain)
            .navigationTitle(.navigationTitle)
            .searchable(
                text: $searchText,
                isPresented: $isSearching,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text(.searchPrompt)
            )
            .autocorrectionDisabled(true)
        }
    }
}

// MARK: - Helper

private extension SearchView {
    var filteredItems: [any SearchableItem] {
        let allItems = Content.allItems
        guard !searchText.isEmpty else { return allItems }

        return allItems.filter {
            $0.label.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let navigationTitle: Self = "Search"
    static let searchPrompt: Self = "Search for feature"
}

