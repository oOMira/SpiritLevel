import SwiftUI

struct LogInjectionView: View {
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

@MainActor
private extension LocalizedStringKey {
    static let placeholderText: Self = "Log Injectin View"
    static let navigationTitle: Self = "Log Injectin"
    static let closeLabel: Self = "Close"
}
private extension String {
    static let xmarkIcon = "xmark"
}

// MARK: - Preview

#Preview("Light Mode") {
    NavigationStack {
        LogInjectionView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        LogInjectionView()
    }
    .preferredColorScheme(.dark)
}

