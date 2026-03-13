import SwiftUI

struct SetupCellView: View {
    let systemImage: SystemImage
    let title: LocalizedStringResource
    let setupAction: () -> Void
    let dismissAction: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            systemImage.image
                .font(.headline)
            Button(action: setupAction, label: {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
            .buttonStyle(.plain)
            Button("", systemImage: "xmark.circle.fill", action: dismissAction)
                .buttonStyle(.plain)
        }
        .accessibilityElement(children: .combine)
    }
}

