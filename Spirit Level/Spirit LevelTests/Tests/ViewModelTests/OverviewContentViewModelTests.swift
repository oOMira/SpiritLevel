import Testing
import Foundation
@testable import Spirit_Level

struct OverviewContentViewModelTests {
    @MainActor
    struct TreatmentPlanRemindersTests {
        private typealias ReminderType = OverviewContentViewModel<AppDependenciesMock>.ReminderConfiguration
        private typealias TreatmentPlanReminderType = OverviewContentViewModel<AppDependenciesMock>.TreatmentPlanReminderConfiguration
        
        @Test func testShowingReminderCell() {
            let viewModel = OverviewContentViewModel(dependencies: makeTimeDependencies(treatmentPlanRepository: .none))
            let showsCell = viewModel.reminders.contains { $0 is TreatmentPlanReminderType && $0.showsCell }
            #expect(showsCell)
        }
        
        @Test func testNotShowingReminderCell() {
            let onePlanViewModel = OverviewContentViewModel(dependencies: makeTimeDependencies(treatmentPlanRepository: .one))
            let showsCellForOnePlan = onePlanViewModel.reminders.contains { $0 is TreatmentPlanReminderType && $0.showsCell }
            #expect(!showsCellForOnePlan)
            
            let toneOfPlansViewModel = OverviewContentViewModel(dependencies: makeTimeDependencies(treatmentPlanRepository: .tone))
            let showsCellForToneOfPlans = toneOfPlansViewModel.reminders.contains { $0 is TreatmentPlanReminderType && $0.showsCell }
            #expect(!showsCellForToneOfPlans)
        }
        
        @Test func allRemindersVisible() {
            let reminders = [getConfiguration(visible: true), getConfiguration(visible: true)]
            let viewModel = OverviewContentViewModel(dependencies: makeTimeDependencies(treatmentPlanRepository: .none),
                                                     reminders: reminders)
            let allRemindersVisibleCount = viewModel.reminders.filter { $0.showsCell }.count
            #expect(allRemindersVisibleCount == reminders.count)
        }
        
        @Test func testClearAll() {
            let reminders = [getConfiguration(visible: true), getConfiguration(visible: true)]
            let viewModel = OverviewContentViewModel(dependencies: makeTimeDependencies(treatmentPlanRepository: .none),
                                                     reminders: reminders)
            viewModel.clearAllReminders()
            let noRemindersVisibleCount = viewModel.reminders.filter { $0.showsCell }.count
            #expect(noRemindersVisibleCount == 0)
        }
        
        @Test func testClearOne() {
            let reminders = [getConfiguration(visible: true), getConfiguration(visible: true)]
            let viewModel = OverviewContentViewModel(dependencies: makeTimeDependencies(treatmentPlanRepository: .none),
                                                     reminders: reminders)
            
            reminders[0].showsCell = false
            let newRemindersVisibleCount = viewModel.reminders.filter { $0.showsCell }.count
            #expect(newRemindersVisibleCount == reminders.count - 1)
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
    private func makeTimeDependencies(treatmentPlanRepository: TreatmentPlanMock) -> AppDependenciesMock {
        .init(appStateManager: .init(),
              appStartRepository: .new,
              injectionRepository: .none,
              labResultsRepository: .none,
              treatmentPlanRepository: treatmentPlanRepository,
              hormoneLevelManager: .init())
    }
}
