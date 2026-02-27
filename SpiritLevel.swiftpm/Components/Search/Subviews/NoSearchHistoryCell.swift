import SwiftUI

struct NoSearchHistoryCell: View {
    var body: some View {
        Text(.emptyHistoryMessage)
            .font(.title3)
            .frame(maxWidth: .infinity)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let emptyHistoryMessage: Self = "No search history yet"
}

private extension CGFloat {
    static let topPadding: Self = 32
}
