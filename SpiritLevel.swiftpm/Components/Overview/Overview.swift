import SwiftUI

struct Overview<AppStateMangerType: AppStateManagable>: View {
    @State private var activeSheet: ShortcutFeature?
    var appStateManager: AppStateMangerType
    
    var body: some  View {
        ZStack(alignment: .bottomTrailing) {
            List {
                OverviewContentView(appStateManager: appStateManager)
            }
            .navigationTitle(.navigationTitle)
            // MARK: - Quick Actions
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .logInjection: LogInjectionView()
                    .presentationDetents([.medium, .large])
                case .logLab: LogLabView()
                    .presentationDetents([.medium, .large])
                }
            }
            
            PhoneQuickActionsView(action: { feature in
                activeSheet = feature
            })
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Quick Actions")
        }
    }
}

// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let navigationTitle: Self = "Overview"
    static let moodTitle: Self = "Mood"
}


