import SwiftUI

struct EmptySearchResultsView: View {
    var body: some View {
        VStack(spacing: .iconTextSpacing) {
            Image(systemName: .magnifyingglassIcon)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            Text(.noResultsTitle)
                .font(.title3)
                .padding(.top)
        }
        .accessibilityElement(children: .combine)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, .topPadding)
    }
}

// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let noResultsTitle: Self = "No Results"
}

private extension String {
    static let magnifyingglassIcon = "magnifyingglass"
}

private extension CGFloat {
    static let iconTextSpacing: Self = 8
    static let topPadding: Self = 50
}
