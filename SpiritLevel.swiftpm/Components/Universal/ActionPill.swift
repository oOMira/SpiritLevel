import SwiftUI

struct ActionPill: View {
    @State private var expanded: Bool = false
    let onTap: () -> Void
    let onLongPress: () -> Void

    var body: some View {
        Image(systemName: "plus")
            .fontWeight(.semibold)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .onTapGesture {
                expanded.toggle()
                onTap()
            }
            .onLongPressGesture(minimumDuration: 0.5) {
                onLongPress()
            }
    }
}
