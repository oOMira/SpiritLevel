import SwiftUI

struct PhoneQuickActionsView: View {
    let action: (ShortcutFeature) -> Void
    
    var body: some View {
        let quickActions: [QuickActionsControl.ActionConfiguration] = ShortcutFeature.allCases.map { feature in
            .init(feature: feature, action: {
                action(feature)
            })
        }

        QuickActionsControl(actions: quickActions)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.bottom, 16)
            .padding(.trailing, 16)
            .ignoresSafeArea(edges: .bottom)
    }
}
