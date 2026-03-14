import SwiftUI

struct RemindersCell: View {
    @ScaledMetric(relativeTo: .body) private var height: CGFloat = 25
    let systemImageName: String
    let title: LocalizedStringResource
    let description: LocalizedStringResource
    let action: () -> Void
    let longPressAction: (() -> Void)?
    
    init(systemImageName: String,
         title: LocalizedStringResource,
         description: LocalizedStringResource,
         action: @escaping () -> Void,
         longPressAction: (() -> Void)? = nil) {
        self.systemImageName = systemImageName
        self.title = title
        self.description = description
        self.action = action
        self.longPressAction = longPressAction
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImageName)
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: height)
                .foregroundStyle(.primary)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onTapGesture {
            action()
        }
        .onLongPressGesture {
            longPressAction?()
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    RemindersCell(
        systemImageName: "bell.badge",
        title: "Set up notifications",
        description: "Get reminders for your injections",
        action: { print("Tapped") },
    )
    .preferredColorScheme(.light)
    .padding()
}

#Preview("Dark Mode") {
    RemindersCell(
        systemImageName: "bell.badge",
        title: "Set up notifications",
        description: "Get reminders for your injections",
        action: { print("Tapped") }
    )
    .preferredColorScheme(.dark)
    .padding()
}
