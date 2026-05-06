import SwiftUI
import HealthDataLogging

typealias AchievementsViewDependencies =
    HasInjectionRepository &
    HasTreatmentPlanRepository &
    HasLabResultsRepository &
    HasAppStartRepository

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
    @ScaledMetric(relativeTo: .body) private var chartHeight: CGFloat = .baseChartHeight

    let viewModel: AchievementsViewModel<Dependencies>

    init(viewModel: AchievementsViewModel<Dependencies>) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            ForEach(Achievement.allCases) { achievement in
                let isDone = viewModel.isAchievementDone(achievement, date: appData.appStartDate)
                HStack {
                    (achievement.image ?? SystemImage.photo.image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius, style: .continuous))
                        .frame(width: chartHeight)
                        .grayscale(isDone ? .color : .gray)
                        .opacity(getImageOpacity(isDone: isDone))
                        .accessibilityIgnoresInvertColors()
                        .overlay {
                            if accessibilityDifferentiateWithoutColor {
                                getAccessibilityOverlay(isDone: isDone)
                            }
                        }
                    VStack(spacing: .textSpacing) {
                        Text(achievement.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(achievement.description)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .fontWeight(isDone ? .bold : .regular)
                }
                .animation(.easeInOut, value: isDone)
                .accessibilityElement(children: .combine)
                .accessibilityValue(isDone ? .completed : .incompleted)
            }
        }
        .listStyle(.plain)
        .navigationTitle(.navigationTitle)
        .accessibilityRotor(.completedAccessibilityRotor) { achievementRotor(done: true) }
        .accessibilityRotor(.incompletedAccessibilityRotor) { achievementRotor(done: false) }
    }
}

// MARK: - Helper

extension AchievementsView {
    private func getImageOpacity(isDone: Bool) -> Double {
        if accessibilityDifferentiateWithoutColor {
            return .mediumOpacity
        } else {
            return isDone ? .highOpacity : .mediumOpacity
        }
    }

    private func achievementRotor(done: Bool) -> some AccessibilityRotorContent {
        ForEach(Achievement.allCases) { achievement in
            if viewModel.isAchievementDone(achievement, date: appData.appStartDate) == done {
                AccessibilityRotorEntry(achievement.name, id: achievement.id)
            }
        }
    }

    private func getAccessibilityOverlay(isDone: Bool) -> some View {
        Image(systemName: isDone ? SystemImage.checkmarkCircle.name : SystemImage.xCircle.name)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(maxHeight: .infinity, alignment: .center)
            .padding(.overlayPadding)
            .accessibilityHidden(true)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let cornerRadius: Self = 8
    static let overlayPadding: Self = 4.0
    static let baseChartHeight: Self = 50.0
    static let textSpacing: Self = 2.0
}

extension Double {
    static let hiddenOpacity: Self = 0.0
    static let highOpacity: Self = 1.0
    static let mediumOpacity: Self = 0.5
    static let color: Self = 0.0
    static let gray: Self = 1.0
}

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Achievements"
    static let completedAccessibilityRotor: Self = "Completed achievements"
    static let incompletedAccessibilityRotor: Self = "Incomplete achievements"
    static let completed: Self = "Completed"
    static let incompleted: Self = "Incomplete"
}
