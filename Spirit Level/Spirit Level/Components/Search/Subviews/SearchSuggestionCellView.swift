import SwiftUI

struct SearchSuggestionCellView: View {
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    
    let appArea: AppArea
    let namespace: Namespace.ID
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
        .matchedTransitionSource(id: appArea, in: namespace)
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
