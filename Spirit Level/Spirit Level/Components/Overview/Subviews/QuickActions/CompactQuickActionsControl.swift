import SwiftUI

// TODO: different style for Landscape
struct CompactQuickActionsControl: View {
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
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.bottom, .padding)
        .padding(.trailing, .padding)
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - QuickActionsControl+ActionConfiguration

extension CompactQuickActionsControl {
    struct ActionConfiguration: Identifiable {
        var id: ShortcutFeature.ID { feature.id }
        
        let feature: ShortcutFeature
        let action: () -> Void
        
        init(feature: ShortcutFeature, action: @escaping () -> Void) {
            self.feature = feature
            self.action = action
        }
    }
}

// MARK: - Constants

private extension CGFloat {
    static let actionSpacing: Self = 28
    static let iconSize: Self = 23
    static let containerPadding: Self = 8
    static let accessibilityHitInset: Self = 6
    static let padding: Self = 16
}

// MARK: - Previews

#Preview("Light Mode") {
    CompactQuickActionsControl(actions: ShortcutFeature.allCases.map {
        .init(feature: $0, action: {})
    })
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    CompactQuickActionsControl(actions: ShortcutFeature.allCases.map {
        .init(feature: $0, action: {})
    })
    .preferredColorScheme(.dark)
}


