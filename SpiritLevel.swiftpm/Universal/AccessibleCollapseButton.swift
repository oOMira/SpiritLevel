import SwiftUI

struct AccessibleCollapseButton: View {
    @Binding private var expanded: Bool
    
    init(expanded: Binding<Bool>) {
        self._expanded = expanded
    }
    
    var body: some View {
        HStack {
            Text(expanded ? .showLessButtonTitle : .showMoreButtonTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: .chevronImage)
                .rotationEffect(.degrees(expanded ? .expandedRotation : .collapsedRotation))
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue(expanded ? .expandedStateDescription : .collapsedStateDescription)
        .accessibilityHint("Double tap to \(expanded ? "collapse" : "expand") the list")
    }
}

private extension Double {
    static let expandedRotation: Self = -180
    static let collapsedRotation: Self = 0
}

private extension LocalizedStringResource {
    static let showMoreButtonTitle: Self = "Show more"
    static let showLessButtonTitle: Self = "Show less"
    static let expandedStateDescription: Self = "Expanded"
    static let collapsedStateDescription: Self = "Collapsed"
}

private extension String {
    static let chevronImage = "chevron.down"
}
