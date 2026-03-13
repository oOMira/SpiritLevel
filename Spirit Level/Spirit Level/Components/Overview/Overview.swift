import SwiftUI

struct Overview<Dependencies: OverviewDependencies>: View {
    
    @State private var activeSheet: ShortcutFeature?
    
    let dependencies: Dependencies
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            let dependency = dependencies
            OverviewContentView(dependencies: dependency)
                .sheet(item: $activeSheet) { sheet in
                    switch sheet {
                    case .logInjection: LogInjectionView(injectionRepository: dependencies.injectionRepository)
                            .presentationDetents([.medium, .large])
                    case .logLab: LogLabResultView(labResultsRepository: dependencies.labResultsRepository)
                            .presentationDetents([.medium, .large])
                    }
                }

            let quickActions: [CompactQuickActionsControl.ActionConfiguration] = ShortcutFeature.allCases.map { feature in
                .init(feature: feature, action: {
                    activeSheet = feature
                })
            }

            CompactQuickActionsControl(actions: quickActions)
                .accessibilityElement(children: .contain)
                .accessibilityLabel(.accessibilityLabel)
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let moodTitle: Self = "Mood"
    static let accessibilityLabel: Self = "Quick Actions"
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        Overview(dependencies: Mocks.appDependencies)
    }
    .environment(AppData())
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        Overview(dependencies: Mocks.appDependencies)
    }
    .environment(AppData())
    .preferredColorScheme(.dark)
}


