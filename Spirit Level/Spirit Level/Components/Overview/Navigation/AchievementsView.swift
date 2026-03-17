import SwiftUI

typealias AchievementsViewDependencies = HasInjectionRepository & HasTreatmentPlanRepository & HasLabResultsRepository & HasAppStartRepository

@Observable
final class AchievementsViewModel<Dependencies: AchievementsViewDependencies>: AchievementsManageable {
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

struct AchievementsView<Dependencies: AchievementsViewDependencies>: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(AppData.self) var appData: AppData
    @ScaledMetric(relativeTo: .body) private var chartHeight: CGFloat = 50
    
    let viewModel: AchievementsViewModel<Dependencies>
    
    init(viewModel: AchievementsViewModel<Dependencies>) {
        self.viewModel = viewModel
    }
                                              
    var body: some View {
        List {
            ForEach(Achievement.allCases) { achievement in
                let isDone = viewModel.isAchievementDone(achievement, date: appData.appStartDate)
                HStack {
                    achievement.image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius, style: .continuous))
                        .frame(width: chartHeight)
                        .grayscale(isDone ? 0.0 : 1.0)
                        .opacity(isDone ? 1.0 : 0.5)
                        .opacity(accessibilityDifferentiateWithoutColor ? 0.5 : 1.0)
                        .accessibilityIgnoresInvertColors()
                        .overlay {
                            if accessibilityDifferentiateWithoutColor {
                                getAccessibilityOverlay(isDone: isDone)
                            }
                        }
                    VStack {
                        Text(achievement.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 2)
                        Text(achievement.description)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .fontWeight(isDone ? .bold : .regular)
                }
                .animation(.easeInOut, value: isDone)
                .accessibilityElement(children: .combine)
                .accessibilityValue(isDone ? "Completed" : "Not completed")
            }
        }
        .listStyle(.plain)
        .navigationTitle(.navigationTitle)
        .accessibilityRotor("Completed Achievements") { achievementRotor(done: true) }
        .accessibilityRotor("Incomplete Achievements") { achievementRotor(done: false) }
    }
    
    func achievementRotor(done: Bool) -> some AccessibilityRotorContent {
        ForEach(Achievement.allCases) { achievement in
            if viewModel.isAchievementDone(achievement, date: appData.appStartDate) == done {
                AccessibilityRotorEntry(achievement.name, id: achievement.id)
            }
        }
    }
    
    func getAccessibilityOverlay(isDone: Bool) -> some View {
        Image(systemName: isDone ? "checkmark.circle" : "x.circle")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(maxHeight: .infinity, alignment: .center)
            .padding(4)
            .accessibilityHidden(true)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let cornerRadius: CGFloat = 8
}

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Achievements"
}
