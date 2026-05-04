import SwiftUI

struct NavigationSectionHeaderView<Destination: View>: View {
    private let title: LocalizedStringResource
    private let destination: Destination

    init(title: LocalizedStringResource, @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.destination = destination()
    }

    var body: some View {
        NavigationLink(destination: destination, label: {
            HStack {
                Text(title)
                SystemImage.chevronForward.image
                    .font(.caption.weight(.semibold))
            }
        })
        .buttonStyle(.plain)
        .accessibilityHint(.accessibilityHint)
    }
}

private extension LocalizedStringResource {
    static let accessibilityHint: Self = "Double tap to open details"
}
