import SwiftUI

struct EmptySearchResultsView: View {
    let emptyType: EmptyType

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            Text(emptyType.title)
                .font(.title3)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 50)
    }
}

// MARK: - EmptySearchResultsView+EmptyType

extension EmptySearchResultsView {
    enum EmptyType: String, Identifiable {
        var id: String { rawValue }
        
        case results
        case query
        
        var title: String {
            switch self {
            case .results: return "No Results"
            case .query: return "Search"
            }
        }
    }
}

// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let noResultsTitle: Self = "No Results"
    static let noResultsMessage: Self = "Try a different spelling or a new search."
}
