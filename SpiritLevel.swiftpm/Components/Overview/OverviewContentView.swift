import SwiftUI

struct OverviewContentView<AppStateManagerType: AppStateManagable>: View {
    @Bindable var appStateManager: AppStateManagerType
    
    var body: some View {
        ForEach(OverviewFeature.allCases) { feature in
            switch feature {
            case .mood:
                Section {
                    if appStateManager.isMoodExpanded {
                        MoodCellView()
                            .accessibilityElement(children: .combine)
                            .accessibilityAddTraits(.isImage)
                            .accessibilityLabel(Mood.happy.rawValue)
                    }
                } header: {
                    ExpandableSectionHeader(title: .moodTitle,
                                            expanded: $appStateManager.isMoodExpanded)
                }
            case .currentLevel:
                Section(feature.label) {
                    CurrentHormoneLevelCellView()
                }
            case .nextInjection:
                Section(feature.label) {
                    NextInjectionCellView()
                }
            case .trend:
                Section(feature.label) {
                    TrendCellView(configurations: [
                        .init(name: "Level", trend: .up),
                        .init(name: "Consistency", trend: .down),
                    ])
                }
            case .achivements:
                Section {
                    AchievementsCellView(isDone: false)
                        .accessibilityElement(children: .contain)
                } header: {
                    NavigationLink(destination: {
                        AchievementsView(isDone: true)
                    }, label: {
                        HStack {
                            Text(feature.label)
                            Image(systemName: "chevron.forward")
                                .font(.caption.weight(.semibold))
                        }
                    })
                    .buttonStyle(.plain)
                    .accessibilityHint("Double tap for details")
                }
            }
        }
    }
}

@MainActor
private extension LocalizedStringKey {
    static let moodTitle: Self = "Mood"
}
