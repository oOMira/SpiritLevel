import Foundation

@Observable
final class AppDependencies<AppStateManagerType: AppStateManageable,
                            AppStartRepositoryType: AppStartManageable,
                            InjectionRepositoryType: InjectionManageable,
                            LabResultsRepositoryType: LabResultsManageable,
                            TreatmentPlanRepositoryType: TreatmentPlanManageable,
                            HormoneManagerType: HormoneLevelManageable>: OverviewContentViewDependencies {

    var appStateManager: AppStateManagerType
    var appStartManger: AppStartRepositoryType
    var injectionRepository: InjectionRepositoryType
    var treatmentPlanRepository: TreatmentPlanRepositoryType
    var hormoneLevelManager: HormoneManagerType
    var labResultsRepository: LabResultsRepositoryType
    
    init(appStateManager: AppStateManagerType,
         appStartManger: AppStartRepositoryType,
         injectionRepository: InjectionRepositoryType,
         treatmentPlanRepository: TreatmentPlanRepositoryType,
         hormoneLevelManager: HormoneManagerType,
         labResultsRepository: LabResultsRepositoryType) {
        self.appStateManager = appStateManager
        self.appStartManger = appStartManger
        self.injectionRepository = injectionRepository
        self.treatmentPlanRepository = treatmentPlanRepository
        self.hormoneLevelManager = hormoneLevelManager
        self.labResultsRepository = labResultsRepository
    }
}

