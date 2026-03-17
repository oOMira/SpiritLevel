import SwiftUI

typealias SettingsDependencies = HasAppStateManager & HasAppStartRepository & HasInjectionRepository & HasLabResultsRepository & HasTreatmentPlanRepository & HasHormoneLevelManager

@Observable
final class SettingsContentViewModel<Dependencies: SettingsDependencies> {
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
