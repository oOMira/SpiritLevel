import SwiftUI

struct CompactOverview<AppStateMangerType: AppStateManagable>: View {
    var appStateManager: AppStateMangerType
    
    var body: some  View {
        NavigationStack {
            List {
                OverviewContentView(appStateManager: appStateManager)
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
