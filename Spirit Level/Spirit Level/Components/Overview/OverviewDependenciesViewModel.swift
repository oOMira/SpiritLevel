import SwiftUI

typealias OverviewDependencies = HasAppStateManager & HasAppStartRepository & HasInjectionRepository & HasLabResultsRepository & HasTreatmentPlanRepository & HasHormoneLevelManager

@Observable
final class OverviewContentViewModel<Dependencies: OverviewDependencies> {
    var reminders: [ReminderConfiguration] = []
    var visibleReminder: ReminderConfiguration? = nil
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        reminders.append(
            .init(showsCell: dependencies.treatmentPlanRepository.latest == nil,
                  systemImageName: .systemImage.calendar.name,
                  title: .getStartedTitle,
                  description: .getStartedDescription,
                  action: { [weak self] configuration in
                      self?.visibleReminder = configuration
                  })
        )
    }
}

extension OverviewContentViewModel {
    @Observable
    final class ReminderConfiguration: Identifiable, Hashable {
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
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let getStartedTitle: Self = "Get started"
    static let getStartedDescription: Self = "Setup a treatment plan"
}
