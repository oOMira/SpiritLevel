import SwiftUI

struct LogLabView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Text(.placeholderText)
        }
        .navigationTitle(.navigationTitle)
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    dismiss()
                } label: {
                    Label(.closeLabel, systemImage: .xmarkIcon)
                }
            }
        }
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let placeholderText: Self = "Log Lab View"
    static let navigationTitle: Self = "Log Lab Results"
    static let closeLabel: Self = "Close"
}
private extension String {
    static let xmarkIcon = "xmark"
}

// MARK: - Preview

#Preview("Light Mode") {
    NavigationStack {
        LogLabView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        LogLabView()
    }
    .preferredColorScheme(.dark)
}

