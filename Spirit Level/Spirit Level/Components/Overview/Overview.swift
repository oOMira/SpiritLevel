import SwiftUI

struct Overview<Dependencies: OverviewDependencies>: View {
    
    @State private var activeSheet: ShortcutFeature?
    
    let dependencies: Dependencies
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            let dependencie = dependencies
            OverviewContentView(dependencies: dependencie)
                .navigationTitle(.navigationTitle)
                // MARK: - Quick Actions
                .sheet(item: $activeSheet) { sheet in
                    switch sheet {
                    case .logInjection: LogInjectionView(injectionRepository: dependencies.injectionRepository)
                            .presentationDetents([.medium, .large])
                    case .logLab: LogLabResultView(labResultsRepository: dependencies.labResultsRepository)
                            .presentationDetents([.medium, .large])
                    }
                }
            
            PhoneQuickActionsView(action: { feature in
                activeSheet = feature
            })
            .accessibilityElement(children: .contain)
            .accessibilityLabel(.accessibilityLabel)
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Overview"
    static let moodTitle: Self = "Mood"
    static let accessibilityLabel: Self = "Quick Actions"
}

