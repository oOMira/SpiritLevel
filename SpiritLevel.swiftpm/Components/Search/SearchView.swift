import SwiftUI

struct SearchView: View {
    @State private var activeSheet: ShortcutFeature?
    @ObservedObject private var appState = AppStateManager.shared
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false

    private var searchHistory: [String] {
        (try? JSONDecoder().decode([String].self, from: Data(appState.searchHistoryData.utf8))) ?? []
    }

    private func addToHistory(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        var history = searchHistory
        history.removeAll { $0 == trimmed }
        history.insert(trimmed, at: 0)
        history = Array(history.prefix(Int.maxHistoryItems))
        if let data = try? JSONEncoder().encode(history) {
            appState.searchHistoryData = String(data: data, encoding: .utf8) ?? "[]"
        }
    }

    private func clearHistory() {
        appState.searchHistoryData = "[]"
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
                                    withAnimation {
                                        clearHistory()
                                    }
                                }, label: {
                                    Text("Clear history")
                                        .font(.footnote.bold())
                                        .foregroundStyle(.red)
                                })
                            }
                            .listRowSeparator(.hidden)
                            ForEach(searchHistory.enumerated(), id: \.offset) { _, query in
                                Text(query)
                                    .listRowBackground(Color.clear)
                            }
                            .onTapGesture { }
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
                } else {
                    SearchInactiveView(activeSheet: $activeSheet,
                                       navigationItems: AppArea.allCases,
                                       actionItems: ShortcutFeature.allCases,
                                       allItems: Content.allItems)
                }
            }
            .animation(.snappy, value: searchText)
            .animation(.snappy, value: searchHistory.isEmpty)
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
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .logInjection:
                    LogInjectionView()
                        .presentationDetents([.medium, .large])
                case .logLab:
                    LogLabView()
                        .presentationDetents([.medium, .large])
                }
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
    static let recentSearchesTitle: Self = "Recent Searches"
    static let clearHistoryButton: Self = "Clear history"
}

private extension Int {
    static let maxHistoryItems: Self = 10
}

// MARK: - Preview
#Preview("Light Mode") {
    SearchView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    SearchView()
        .preferredColorScheme(.dark)
}



