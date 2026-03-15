import SwiftUI

struct RemindersCell: View {
    @ScaledMetric(relativeTo: .body) private var imageWidth: CGFloat = 20
    let systemImageName: String
    let title: LocalizedStringResource
    let description: LocalizedStringResource
    let action: () -> Void
    let dismissAction: () -> Void
    
    init(systemImageName: String,
         title: LocalizedStringResource,
         description: LocalizedStringResource,
         action: @escaping () -> Void,
         dismissAction: @escaping () -> Void) {
        self.systemImageName = systemImageName
        self.title = title
        self.description = description
        self.action = action
        self.dismissAction = dismissAction
    }

    var body: some View {
        HStack {
            Button(action: action, label: {
                Image(systemName: systemImageName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: imageWidth)
                    .padding(.trailing, 4)
                    .padding(.leading, 4)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                    Text(description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            })
            .buttonStyle(.plain)
            Divider()
            Button(action: {
                dismissAction()
            }, label: {
                Image(systemName: "xmark.circle.fill")
            })
            .padding(.leading, 4)
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 8,
                             leading: 4,
                             bottom: 8,
                             trailing: 4))
        .listRowBackground(Color.clear)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .accessibilityElement(children: .combine)
        .clipShape(RoundedRectangle(cornerSize: .init(width: 42, height: 42)))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 0)
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    List {
        RemindersCell(
            systemImageName: "bell.badge",
            title: "Set up notifications",
            description: "Get reminders for your injections",
            action: { print("Tapped") },
            dismissAction: { print("dismiss tapped") }
        )
        .preferredColorScheme(.light)
    }
}

#Preview("Dark Mode") {
    List {
        RemindersCell(
            systemImageName: "bell.badge",
            title: "Set up notifications",
            description: "Get reminders for your injections",
            action: { print("Tapped") },
            dismissAction: { print("dismiss tapped") }
        )
        .preferredColorScheme(.dark)
    }
}
