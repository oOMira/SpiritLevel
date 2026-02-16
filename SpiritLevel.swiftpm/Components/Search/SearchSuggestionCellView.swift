import SwiftUI

struct SearchSuggestionCellView: View {
    let configuration: Configuration
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                configuration.image
                    .font(.title2)
                Spacer()
                Text(configuration.label)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(configuration.color.opacity(0.75))
        )
    }
}

// MARK: - SearchSuggestionCellView+Configuration

extension SearchSuggestionCellView {
    struct Configuration {
        let label: String
        let image: Image
        let color: Color
    }
}
