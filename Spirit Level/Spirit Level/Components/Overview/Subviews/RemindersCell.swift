import SwiftUI


struct Configuration {
    let systemImageName: String
    let title: LocalizedStringResource
    let description: LocalizedStringResource
    let action: () -> Void
    let dismissAction: () -> Void
}

struct RemindersCell: View {
    @ScaledMetric(relativeTo: .body) private var imageWidth: CGFloat = 20
    let configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }

    var body: some View {
        HStack {
            Button(action: configuration.action, label: {
                Image(systemName: configuration.systemImageName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: imageWidth)
                    .padding(.trailing, 4)
                    .padding(.leading, 4)
                VStack(alignment: .leading, spacing: 2) {
                    Text(configuration.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                    Text(configuration.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            })
            .buttonStyle(.plain)
            Divider()
            Button(action: {
                configuration.dismissAction()
            }, label: {
                Image(systemName: "xmark.circle.fill")
            })
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .listRowSeparator(.hidden)
        .listRowInsets(.vertical, 8)
        .listRowInsets(.horizontal, 4)
        .listRowBackground(Color.clear)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 42))
        .accessibilityElement(children: .combine)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 0)
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    List {
        RemindersCell(configuration: .init(
            systemImageName: "bell.badge",
            title: "Set up notifications",
            description: "Get reminders for your injections",
            action: { print("Tapped") },
            dismissAction: { print("dismiss tapped") })
        )
        .preferredColorScheme(.light)
    }
}

#Preview("Dark Mode") {
    List {
        RemindersCell(configuration: .init(
            systemImageName: "bell.badge",
            title: "Set up notifications",
            description: "Get reminders for your injections",
            action: { print("Tapped") },
            dismissAction: { print("dismiss tapped") } )
        )
        .preferredColorScheme(.dark)
    }
}
