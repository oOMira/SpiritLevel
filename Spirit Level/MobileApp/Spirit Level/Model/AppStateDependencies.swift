import Foundation
import HealthDataLogging

typealias AppDependenciesProtocol =
    HasAppStateManager &
    HasAppStartRepository &
    HasInjectionRepository &
    HasLabResultsRepository &
    HasTreatmentPlanRepository &
    HasTreatmentPlanConfigurationRepository &
    HasHormoneLevelManager

// MARK: - Implementation

@Observable
final class AppDependencies<AppStateMgr: AppStateManageable,
                            AppStartRepo: AppStartManageable,
                            InjectionRepo: InjectionManageable,
                            LabResultsRepo: LabResultsManageable,
                            TreatmentPlanRepo: TreatmentPlanManageable,
                            ConfigurationRepo: TreatmentPlanConfigurationManageable,
                            HormoneLevelMgr: HormoneLevelManageable>: AppDependenciesProtocol {

    var appStateManager: AppStateMgr
    var appStartRepository: AppStartRepo
    var injectionRepository: InjectionRepo
    var labResultsRepository: LabResultsRepo
    var treatmentPlanRepository: TreatmentPlanRepo
    var treatmentPlanConfigurationRepository: ConfigurationRepo
    var hormoneLevelManager: HormoneLevelMgr

    init(appStateManager: AppStateMgr,
         appStartRepository: AppStartRepo,
         injectionRepository: InjectionRepo,
         labResultsRepository: LabResultsRepo,
         treatmentPlanRepository: TreatmentPlanRepo,
         treatmentPlanConfigurationRepository: ConfigurationRepo,
         hormoneLevelManager: HormoneLevelMgr) {
        self.appStateManager = appStateManager
        self.appStartRepository = appStartRepository
        self.injectionRepository = injectionRepository
        self.labResultsRepository = labResultsRepository
        self.treatmentPlanRepository = treatmentPlanRepository
        self.treatmentPlanConfigurationRepository = treatmentPlanConfigurationRepository
        self.hormoneLevelManager = hormoneLevelManager
    }
}
