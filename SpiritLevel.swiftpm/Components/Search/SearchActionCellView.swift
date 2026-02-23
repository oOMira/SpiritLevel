import SwiftUI

struct SearchActionCellView: View {
    let configuration: Configuration

    var body: some View {
        VStack {
            configuration.image
                .font(.title)
                .padding(.top)
            Text(configuration.label)
                .font(.default)
                .padding()
        }
        .containerRelativeFrame(.horizontal,
                                count: .horizontalCount,
                                spacing: .horizontalSpacing)
        .background(
            RoundedRectangle(cornerRadius: .cornerRadius, style: .continuous)
                .fill(.gray.opacity(.backgroundOpacity))
        )
    }
}

extension SearchActionCellView {
    struct Configuration {
        let label: String
        let image: Image
    }
}

// MARK: - Constants

private extension Int {
    static let horizontalCount: Self = 2
}

private extension CGFloat {
    static let horizontalSpacing: Self = 16
    static let cornerRadius: Self = 20
}

private extension Double {
    static let backgroundOpacity: Self = 0.75
}

// MARK: - Preview

#Preview("Light Mode") {
    ScrollView(.horizontal) {
        HStack(spacing: 16) {
            SearchActionCellView(
                configuration: .init(
                    label: "Log Injection",
                    image: Image(systemName: "plus.circle.fill")
                )
            )
            SearchActionCellView(
                configuration: .init(
                    label: "Log Lab",
                    image: Image(systemName: "testtube.2")
                )
            )
        }
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ScrollView(.horizontal) {
        HStack(spacing: 16) {
            SearchActionCellView(
                configuration: .init(
                    label: "Log Injection",
                    image: Image(systemName: "plus.circle.fill")
                )
            )
            SearchActionCellView(
                configuration: .init(
                    label: "Log Lab",
                    image: Image(systemName: "testtube.2")
                )
            )
        }
    }
    .padding()
    .preferredColorScheme(.dark)
}

