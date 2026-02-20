import SwiftUI

struct ActionPill: View {
    @State private var expanded: Bool = false
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "syringe")
                .onTapGesture {
                    expanded.toggle()
                    onTap()
                }
            Divider()
                .frame(maxWidth: 20)
            Image(systemName: "heart.text.clipboard")
                .onTapGesture {
                    expanded.toggle()
                    onTap()
                }
        }
        .font(.system(size: 22))
        .padding(8)
        .glassEffect()
    }
}
