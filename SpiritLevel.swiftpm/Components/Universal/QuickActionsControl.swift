import SwiftUI

struct QuickActionsControl: View {
    @State private var expanded: Bool = false
    let actions: [ActionConfiguration]

    var body: some View {
        VStack(spacing: .actionSpacing) {
            ForEach(actions) { action in
                Button(action: action.action, label: {
                    action.feature.image
                })
                .accessibilityLabel(action.feature.label)
                .foregroundStyle(.primary)
                .contentShape(.accessibility, Circle().inset(by: -.accessibilityHitInset))
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
    static let actionSpacing: Self = 28
    static let iconSize: Self = 23
    static let containerPadding: Self = 8
    static let accessibilityHitInset: Self = 6
}

