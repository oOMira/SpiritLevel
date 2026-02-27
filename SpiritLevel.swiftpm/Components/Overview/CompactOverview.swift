import SwiftUI

struct CompactOverview<AppStateMangerType: AppStateManagable,
                       InjectionReposetoryType: InjectionManagable>: View {
    
    let appStateManager: AppStateMangerType
    let injectionReposetory: InjectionReposetoryType
    
    var body: some  View {
        NavigationStack {
            List {
                OverviewContentView(appStateManager: appStateManager, injectionRepository: injectionReposetory)
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
