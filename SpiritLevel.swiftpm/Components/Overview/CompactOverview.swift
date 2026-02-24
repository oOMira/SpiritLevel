import SwiftUI

struct CompactOverview: View {
    @ObservedObject private var appState = AppStateManager.shared
    
    var body: some  View {
        ZStack(alignment: .bottomTrailing) {
            List {
                OverviewContentView()
            }
            .navigationTitle(.navigationTitle)
        }
    }
}

// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let navigationTitle: Self = "Overview"
    static let moodTitle: Self = "Mood"
}

// MARK: - Preview

#Preview {
    Overview()
}

