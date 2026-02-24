import SwiftUI

struct OverviewContentView: View {
    @ObservedObject private var appState = AppStateManager.shared
    
    var body: some View {
        ForEach(OverviewFeature.allCases) { feature in
            switch feature {
            case .mood:
                Section {
                    if appState.isMoodExpanded { MoodCellView() }
                } header: {
                    ExpandableSectionHeader(title: .moodTitle, expanded: $appState.isMoodExpanded)
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
                    AchievementsCellView()
                } header: {
                    NavigationLink(destination: {
                        AchievementsView()
                    }, label: {
                        HStack {
                            Text(feature.label)
                            Image(systemName: "chevron.forward")
                                .font(.caption.weight(.semibold))
                        }
                    })
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

@MainActor
private extension LocalizedStringKey {
    static let moodTitle: Self = "Mood"
}
