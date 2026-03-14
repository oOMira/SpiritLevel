import Foundation

typealias AppDependenciesProtocol = HasAppStateManager & HasAppStartRepository & HasSearchResultsManager & HasInjectionRepository & HasLabResultsRepository & HasTreatmentPlanRepository & HasHormoneLevelManager

// MARK: - Implementation

@Observable
final class AppDependencies<AppStateManagerType: AppStateManageable,
                            AppStartRepositoryType: AppStartManageable,
                            SearchResultsManagerType: SearchResultsManageable,
                            InjectionRepositoryType: InjectionManageable,
                            LabResultsRepositoryType: LabResultsManageable,
                            TreatmentPlanRepositoryType: TreatmentPlanManageable,
                            HormoneLevelManagerType: HormoneLevelManageable>: AppDependenciesProtocol {
    
    var appStateManager: AppStateManagerType
    var appStartRepository: AppStartRepositoryType
    var searchResultsManager: SearchResultsManagerType
    var injectionRepository: InjectionRepositoryType
    var labResultsRepository: LabResultsRepositoryType
    var treatmentPlanRepository: TreatmentPlanRepositoryType
    var hormoneLevelManager: HormoneLevelManagerType
    
    init(appStateManager: AppStateManagerType,
         appStartRepository: AppStartRepositoryType,
         searchResultsManager: SearchResultsManagerType,
         injectionRepository: InjectionRepositoryType,
         labResultsRepository: LabResultsRepositoryType,
         treatmentPlanRepository: TreatmentPlanRepositoryType,
         hormoneLevelManager: HormoneLevelManagerType) {
        self.appStateManager = appStateManager
        self.appStartRepository = appStartRepository
        self.searchResultsManager = searchResultsManager
        self.injectionRepository = injectionRepository
        self.labResultsRepository = labResultsRepository
        self.treatmentPlanRepository = treatmentPlanRepository
        self.hormoneLevelManager = hormoneLevelManager
    }
}
