import SwiftUI

struct QuickActionsControl: View {
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
                .accessibilityShowsLargeContentViewer {
                    Label(action.feature.label, systemImage: action.feature.systemImageName)
                }
            }
        }
        .font(.system(size: .iconSize))
        .padding(.containerPadding)
        .glassEffect(.regular.interactive())
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

