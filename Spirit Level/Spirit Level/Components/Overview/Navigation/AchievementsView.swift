import SwiftUI

typealias AchievementsViewDependencies = HasInjectionRepository & HasTreatmentPlanRepository & HasLabResultsRepository & HasAppStartRepository

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
                        .clipShape(RoundedRectangle(cornerRadius: .cornerRadius,
                                                    style: .continuous))
                        .frame(width: chartHeight)
                        .grayscale(isDone ? 0.0 : 1.0)
                        .opacity(isDone ? 1.0 : 0.5)
                        .opacity(accessibilityDifferentiateWithoutColor ? 0.5 : 1.0)
                        .accessibilityIgnoresInvertColors()
                        .overlay {
                            if accessibilityDifferentiateWithoutColor {
                                Image(systemName: isDone
                                      ? "checkmark.circle"
                                      : "x.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(maxHeight: .infinity, alignment: .center)
                                .padding(4)
                                .accessibilityHidden(true)
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
                .accessibilityElement(children: .combine)
                .accessibilityValue(isDone ? "Completed" : "Not completed")
            }
        }
        .listStyle(.plain)
        .navigationTitle(.navigationTitle)
        .accessibilityRotor("Completed Achievements") {
            ForEach(Achievement.allCases) { achievement in
                if viewModel.isAchievementDone(achievement, date: appData.appStartDate) {
                    AccessibilityRotorEntry(achievement.name, id: achievement.id)
                }
            }
        }
        .accessibilityRotor("Incomplete Achievements") {
            ForEach(Achievement.allCases) { achievement in
                if !viewModel.isAchievementDone(achievement, date: appData.appStartDate) {
                    AccessibilityRotorEntry(achievement.name, id: achievement.id)
                }
            }
        }
    }
}

// MARK: - Constants

private extension CGFloat {
    static let cornerRadius: CGFloat = 8
}

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Achievements"
}

extension Array where Element: TreatmentPlan {
    // TODO: Test performance and provide optimization or async verison if needed
    func getPlannedInjectionsList(till date: Date) -> [(date: Date, plan: TreatmentPlan)] {
        let sortedSelf = self.sorted { $0.firstInjectionDate.start < $1.firstInjectionDate.start }
        return (0..<count).compactMap { index -> [(date: Date, plan: TreatmentPlan)]? in
            var currentArray = [(date: Date, plan: TreatmentPlan)]()
            let currentPlan = sortedSelf[index]
            let startDate = currentPlan.firstInjectionDate.start
            let endDate = sortedSelf.element(at: index + 1)?.firstInjectionDate.start ?? date.start
            var currentDate = startDate
            while currentDate <= endDate && currentDate <= date.start {
                currentArray.append((currentDate, currentPlan))
                currentDate = Calendar.current.date(byAdding: .day, value: currentPlan.frequency, to: currentDate) ?? .distantFuture
            }
            return currentArray
        }
        .flatMap { $0 }
    }
}

extension Array {
    func element(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
}
