import SwiftUI

struct CompactOverview<AppStateManagerType: AppStateManageable,
                       AppStartRepositoryType: AppStartManageable,
                       InjectionRepositoryType: InjectionManageable,
                       LabResultsRepositoryType: LabResultsManageable,
                       TreatmentPlanRepositoryType: TreatmentPlanManageable,
                       HormoneManagerType: HormoneLevelManageable>: View {
    
    private let appStateManager: AppStateManagerType
    private let appStartRepository: AppStartRepositoryType
    private let injectionRepository: InjectionRepositoryType
    private let labResultsRepository: LabResultsRepositoryType
    private let treatmentPlanRepository: TreatmentPlanRepositoryType
    private let hormoneManager: HormoneManagerType
    
    init(appStateManager: AppStateManagerType,
         appStartRepository: AppStartRepositoryType,
         injectionRepository: InjectionRepositoryType,
         labResultsRepository: LabResultsRepositoryType,
         treatmentPlanRepository: TreatmentPlanRepositoryType,
         hormoneManager: HormoneManagerType) {
        self.appStateManager = appStateManager
        self.appStartRepository = appStartRepository
        self.injectionRepository = injectionRepository
        self.labResultsRepository = labResultsRepository
        self.treatmentPlanRepository = treatmentPlanRepository
        self.hormoneManager = hormoneManager
    }
    
    var body: some View {
        let dependencie = AppDependencies(appStateManager: appStateManager,
                                          appStartManger: appStartRepository,
                                          injectionRepository: injectionRepository,
                                          treatmentPlanRepository: treatmentPlanRepository,
                                          hormoneLevelManager: hormoneManager,
                                          labResultsRepository: labResultsRepository)
        OverviewContentView(viewModel: dependencie)
        .navigationTitle(.navigationTitle)
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Overview"
    static let moodTitle: Self = "Mood"
}
