import Testing
import HealthDataLogging
import SpiritLevelSharedTesting
import Foundation
@testable import Spirit_Level

@Suite("Overview Content View Model", .tags(.viewModel))
struct OverviewContentViewModelTests {
    @Suite("Treatment Plan Reminders", .tags(.treatmentPlans))
    @MainActor
    struct TreatmentPlanRemindersTests {
        private typealias ReminderType = OverviewContentViewModel<AppDependenciesMock>.ReminderConfiguration
        private typealias TreatmentPlanReminderType = OverviewContentViewModel<AppDependenciesMock>.TreatmentPlanReminderConfiguration

        @Test("Shows treatment plan reminder")
        func testShowingReminderCell() {
            let viewModel = OverviewContentViewModel(dependencies: makeTimeDependencies(treatmentPlanRepository: .none))
            let showsCell = viewModel.reminders.contains { $0 is TreatmentPlanReminderType && $0.showsCell }
            #expect(showsCell, "Reminder should be shown without plan")
        }

        @Test("Hides treatment plan reminder")
        func testNotShowingReminderCell() {
            let onePlanViewModel = OverviewContentViewModel(dependencies: makeTimeDependencies(treatmentPlanRepository: .one))
            let showsCellForOnePlan = onePlanViewModel.reminders.contains { $0 is TreatmentPlanReminderType && $0.showsCell }
            #expect(!showsCellForOnePlan, "Should be hidden with one plan")

            let manyPlansViewModel = OverviewContentViewModel(dependencies: makeTimeDependencies(treatmentPlanRepository: .many))
            let showsCellForManyPlans = manyPlansViewModel.reminders.contains { $0 is TreatmentPlanReminderType && $0.showsCell }
            #expect(!showsCellForManyPlans, "Should be hidden with many plans")
        }

        @Test("All reminders are visible")
        func allRemindersVisible() {
            let reminders = [getConfiguration(visible: true), getConfiguration(visible: true)]
            let viewModel = OverviewContentViewModel(dependencies: makeTimeDependencies(treatmentPlanRepository: .none),
                                                     reminders: reminders)
            let allRemindersVisibleCount = viewModel.reminders.filter { $0.showsCell }.count
            #expect(allRemindersVisibleCount == reminders.count, "All reminders should be visible")
        }

        @Test("Clear all reminders")
        func testClearAll() {
            let reminders = [getConfiguration(visible: true), getConfiguration(visible: true)]
            let viewModel = OverviewContentViewModel(dependencies: makeTimeDependencies(treatmentPlanRepository: .none),
                                                     reminders: reminders)
            viewModel.clearAllReminders()
            let noRemindersVisibleCount = viewModel.reminders.filter { $0.showsCell }.count
            #expect(noRemindersVisibleCount == 0, "No reminders should be visible after clear")
        }

        @Test("Clear one reminder")
        func testClearOne() {
            let reminders = [getConfiguration(visible: true), getConfiguration(visible: true)]
            let viewModel = OverviewContentViewModel(dependencies: makeTimeDependencies(treatmentPlanRepository: .none),
                                                     reminders: reminders)

            reminders[0].showsCell = false
            let newRemindersVisibleCount = viewModel.reminders.filter { $0.showsCell }.count
            #expect(newRemindersVisibleCount == reminders.count - 1, "One fewer reminder should be visible")
        }
    }
}
// MARK: - TreatmentPlanRemindersTests+Helper

private extension OverviewContentViewModelTests.TreatmentPlanRemindersTests {
    private func getConfiguration(visible: Bool) -> ReminderType {
        .init(showsCell: visible, systemImageName: "", title: "", description: "", action: { _ in })
    }
}

private extension OverviewContentViewModelTests.TreatmentPlanRemindersTests {
    private func makeTimeDependencies(treatmentPlanRepository: TreatmentPlanManagerMock) -> AppDependenciesMock {
        .init(appStateManager: .init(),
              appStartRepository: .new,
              injectionRepository: .none,
              labResultsRepository: .none,
              treatmentPlanRepository: treatmentPlanRepository,
              treatmentPlanConfigurationRepository: .none,
              hormoneLevelManager: .init())
    }
}
