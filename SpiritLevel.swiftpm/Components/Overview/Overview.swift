import SwiftUI

struct Overview: View {
    @State private var activeSheet: ShortcutFeature?
    @ObservedObject private var appState = AppStateManager.shared
    
    var body: some  View {
        ZStack(alignment: .bottomTrailing) {
            List {
                OverviewContentView()
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

