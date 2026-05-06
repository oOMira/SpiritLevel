import SwiftUI

struct SearchActionCellView: View {
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    let configuration: Configuration

    var body: some View {
        VStack {
            configuration.image
                .font(.title)
                .padding(.top)
            Text(configuration.label)
                .font(.title3)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: .cornerRadius, style: .continuous)
                .fill(.gray.opacity(.backgroundOpacity(increasedContrast: colorSchemeContrast == .increased)))
        )
    }
}

extension SearchActionCellView {
    struct Configuration {
        let label: LocalizedStringResource
        let image: Image
    }
}

// MARK: - Constants

private extension CGFloat {
    static let horizontalSpacing: Self = 16
    static let cornerRadius: Self = 20
}

private extension Double {
    static func backgroundOpacity(increasedContrast: Bool) -> Self {
        increasedContrast ? 0.3 : 0.75
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    SearchActionCellView(configuration: .init(
        label: "Log Injection",
        image: Image(systemName: "syringe")
    ))
    .frame(width: 160, height: 120)
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    SearchActionCellView(configuration: .init(
        label: "Log Injection",
        image: Image(systemName: "syringe")
    ))
    .frame(width: 160, height: 120)
    .preferredColorScheme(.dark)
}
