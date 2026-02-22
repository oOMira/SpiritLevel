import SwiftUI

struct ExpandableSectionHeader: View {
    let title: LocalizedStringKey
    @Binding var expanded: Bool
    
    var body: some View {
        Button(action: {
            expanded.toggle()
        }, label: {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: .chevronImage)
                    .font(.caption.weight(.semibold))
                    .rotationEffect(.degrees(expanded ? 0 : -90))
            }
        })
        .buttonStyle(.plain)
    }
}

// MARK: - Constants

private extension String {
    static let chevronImage = "chevron.down"
}
