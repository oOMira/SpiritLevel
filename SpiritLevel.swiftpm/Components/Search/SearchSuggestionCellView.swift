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
            RoundedRectangle(cornerRadius: .cornerRadius, style: .continuous)
                .fill(configuration.color.opacity(.backgroundOpacity))
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

// MARK: - Constants

private extension CGFloat {
    static let cornerRadius: Self = 20
}

private extension Double {
    static let backgroundOpacity: Self = 0.75
}

// MARK: - Preview

#Preview("Light Mode") {
    List {
        SearchSuggestionCellView(
            configuration: .init(
                label: "Overview",
                image: Image(systemName: "house"),
                color: .blue
            )
        )
        SearchSuggestionCellView(
            configuration: .init(
                label: "Settings",
                image: Image(systemName: "gear"),
                color: .green
            )
        )
    }
    .listStyle(.plain)
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    List {
        SearchSuggestionCellView(
            configuration: .init(
                label: "Overview",
                image: Image(systemName: "house"),
                color: .blue
            )
        )
        SearchSuggestionCellView(
            configuration: .init(
                label: "Settings",
                image: Image(systemName: "gear"),
                color: .green
            )
        )
    }
    .listStyle(.plain)
    .preferredColorScheme(.dark)
}
