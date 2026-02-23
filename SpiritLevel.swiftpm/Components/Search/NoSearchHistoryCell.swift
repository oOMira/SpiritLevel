import SwiftUI

struct NoSearchHistoryCell: View {
    var body: some View {
        Text(.emptyHistoryMessage)
            .font(.title3)
            .frame(maxWidth: .infinity)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, .topPadding)
            .padding(.horizontal)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let emptyHistoryMessage: Self = "No search history yet"
}

private extension CGFloat {
    static let topPadding: Self = 32
}

// MARK: - Preview

#Preview("Light Mode") {
    List {
        NoSearchHistoryCell()
            .listRowSeparator(.hidden)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    List {
        NoSearchHistoryCell()
            .listRowSeparator(.hidden)
    }
    .preferredColorScheme(.dark)
}
