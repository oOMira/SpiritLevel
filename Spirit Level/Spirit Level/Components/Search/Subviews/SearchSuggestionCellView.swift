import SwiftUI

struct SearchSuggestionCellView: View {
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    
    let appArea: AppArea
    let pressed: () -> Void
    
    var body: some View {
        Button(action: {
            pressed()
        }, label: {
            VStack(alignment: .leading) {
                HStack {
                    appArea.image
                        .font(.title2)
                    Spacer()
                    Text(appArea.label)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: .cornerRadius, style: .continuous)
                    .fill(appArea.accentColor.opacity(.backgroundOpacity(increasedContrast:colorSchemeContrast == .increased)))
            )
        })
    }
}

// MARK: AppArea+AccentColor

private extension AppArea {
    var accentColor: Color {
        switch self {
        case .overview: .red
        case .statistics: .green
        case .settings: .blue
        }
    }
}

// MARK: - Constants

private extension CGFloat {
    static let cornerRadius: Self = 20
}

private extension Double {
    static func backgroundOpacity(increasedContrast: Bool) -> Self {
        increasedContrast ? 0.3 : 0.75
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    List {
        SearchSuggestionCellView(appArea: .overview, pressed: {})
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    List {
        SearchSuggestionCellView(appArea: .overview, pressed: {})
    }
    .preferredColorScheme(.dark)
}
