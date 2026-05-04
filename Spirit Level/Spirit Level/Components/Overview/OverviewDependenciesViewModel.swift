import SwiftUI

typealias OverviewDependencies =
    HasAppStateManager &
    HasAppStartRepository &
    HasInjectionRepository &
    HasLabResultsRepository &
    HasTreatmentPlanRepository &
    HasHormoneLevelManager

@Observable
final class OverviewContentViewModel<Dependencies: OverviewDependencies> {
    var reminders: [ReminderConfiguration]
    var visibleReminder: ReminderConfiguration?
    var dependencies: Dependencies

    init(dependencies: Dependencies, reminders: [ReminderConfiguration]) {
        self.dependencies = dependencies
        self.reminders = reminders
    }

    convenience init(dependencies: Dependencies) {
        self.init(dependencies: dependencies, reminders: [])

        self.reminders = [
            TreatmentPlanReminderConfiguration(
                showsCell: dependencies.treatmentPlanRepository.getLatest() == nil,
                action: { [weak self] configuration in
                    self?.visibleReminder = configuration
                })
        ]
    }

    func clearAllReminders() {
        withAnimation { reminders.forEach { $0.showsCell = false } }
    }
}

extension OverviewContentViewModel {
    @Observable
    class ReminderConfiguration: Identifiable, Hashable {
        // Hint: `showsCell` is a workaround to fix animations.
        var showsCell: Bool
        let systemImageName: String
        let title: LocalizedStringResource
        let description: LocalizedStringResource
        let action: (OverviewContentViewModel.ReminderConfiguration) -> Void
        var dismissAction: () -> Void { { [weak self] in
            withAnimation { self?.showsCell = false }
        } }

        init(showsCell: Bool,
             systemImageName: String,
             title: LocalizedStringResource,
             description: LocalizedStringResource,
             action: @escaping (OverviewContentViewModel.ReminderConfiguration) -> Void) {
            self.showsCell = showsCell
            self.systemImageName = systemImageName
            self.title = title
            self.description = description
            self.action = action
        }

        static func == (lhs: ReminderConfiguration, rhs: ReminderConfiguration) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    final class TreatmentPlanReminderConfiguration: ReminderConfiguration {
        convenience init(showsCell: Bool, action: @escaping (OverviewContentViewModel.ReminderConfiguration) -> Void) {
            self.init(showsCell: showsCell,
                  systemImageName: SystemImage.calendar.name,
                  title: .getStartedTitle,
                  description: .getStartedDescription,
                  action: action)
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let getStartedTitle: Self = "Get Started"
    static let getStartedDescription: Self = "Set up a treatment plan"
}
