import SwiftUI

struct EmptySearchResultsView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            Text(.noResultsTitle)
                .font(.title3)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 50)
    }
}

// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let noResultsTitle: Self = "No Results"
}
