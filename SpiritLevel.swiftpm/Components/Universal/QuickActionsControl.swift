import SwiftUI

struct QuickActionsControl: View {
    @State private var expanded: Bool = false
    let actions: [ActionConfiguration]

    var body: some View {
        VStack(spacing: 25) {
            ForEach(actions) { action in
                action.feature.image
                    .onTapGesture(perform: action.action)
            }
        }
        .font(.system(size: 22))
        .padding(8)
        .glassEffect()
    }
}

extension QuickActionsControl {
    struct ActionConfiguration: Identifiable {
        var id: ShortcutFeature.ID { feature.id }
        
        let feature: ShortcutFeature
        let action: () -> Void
    }
}
