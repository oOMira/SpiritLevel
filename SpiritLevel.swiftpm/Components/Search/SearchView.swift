import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @AppStorage("searchHistory") private var searchHistoryData: String = "[]"

    private var searchHistory: [String] {
        (try? JSONDecoder().decode([String].self, from: Data(searchHistoryData.utf8))) ?? []
    }

    private func addToHistory(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        var history = searchHistory
        history.removeAll { $0 == trimmed }   // remove duplicate
        history.insert(trimmed, at: 0)        // most recent first
        history = Array(history.prefix(10))   // limit to 10
        if let data = try? JSONEncoder().encode(history) {
            searchHistoryData = String(data: data, encoding: .utf8) ?? "[]"
        }
    }

    var body: some View {
        NavigationView {
            List {
                if isSearching {
                    if searchText.isEmpty {
                        if searchHistory.isEmpty {
                            NoSearchHistoryCell()
                                .listRowSeparator(.hidden)
                        } else {
                            HStack {
                                Text("Recent Searches")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Button(action: {
                                    print("Clear history")
                                }, label: {
                                    Text("Clear history")
                                        .font(.footnote.bold())
                                        .foregroundStyle(.red)
                                })
                            }
                            .listRowSeparator(.hidden)
                            ForEach(searchHistory.enumerated(), id: \.offset) { _, query in
                                Text(query)
                            }
                        }
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
            .onSubmit(of: .search) {
                addToHistory(searchText)
            }
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

