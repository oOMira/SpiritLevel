import SwiftUI

struct QuickActionsControl: View {
    @State private var expanded: Bool = false
    let actions: [ActionConfiguration]

    var body: some View {
        VStack(spacing: .actionSpacing) {
            ForEach(actions) { action in
                action.feature.image
                    .onTapGesture(perform: action.action)
            }
        }
        .font(.system(size: .iconSize))
        .padding(.containerPadding)
        .glassEffect()
    }
}

// MARK: - QuickActionsControl+ActionConfiguration

extension QuickActionsControl {
    struct ActionConfiguration: Identifiable {
        var id: ShortcutFeature.ID { feature.id }
        
        let feature: ShortcutFeature
        let action: () -> Void
    }
}
// MARK: - Constants

private extension CGFloat {
    static let actionSpacing: Self = 25
    static let iconSize: Self = 22
    static let containerPadding: Self = 8
}

