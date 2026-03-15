import SwiftUI

struct RemindersCell: View {
    @ScaledMetric(relativeTo: .body) private var imageWidth: CGFloat = 25
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
        HStack(spacing: 16) {
            Image(systemName: systemImageName)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: imageWidth)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                Text(description)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { action() }
        .onLongPressGesture { longPressAction?() }
        .accessibilityElement(children: .combine)
        .padding(.leading, 4)
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
