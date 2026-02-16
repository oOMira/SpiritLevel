import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(Content.allItems, id: \.id) {
                    SearchResultCell(label: $0.label, image: $0.image)
                }
            }
            .listStyle(.plain)
            .navigationTitle(.navigationTitle)
        }
    }
}

@MainActor
private extension LocalizedStringKey {
    static let navigationTitle: Self = "Search"
}

// MARK: - SearchResultCell

private struct SearchResultCell: View {
    let label: String
    let image: Image
    
    var body: some View {
        HStack {
            image
            Text(label)
        }
    }
}
