import SwiftUI
import HealthDataLogging

typealias SettingsDependencies =
    HasAppStateManager &
    HasAppStartRepository &
    HasInjectionRepository &
    HasLabResultsRepository &
    HasTreatmentPlanRepository &
    HasTreatmentPlanConfigurationRepository &
    HasHormoneLevelManager

@Observable
final class SettingsContentViewModel<Dependencies: SettingsDependencies> {
    var dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
