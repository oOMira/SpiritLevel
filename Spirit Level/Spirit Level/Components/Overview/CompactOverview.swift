import SwiftUI

// TODO: Add animation to serch

struct CompactOverview<AppStateManagerType: AppStateManageable,
                       AppStartRepositoryType: AppStartManageable,
                       InjectionRepositoryType: InjectionManageable,
                       LabResultsRepositoryType: LabResultsManageable,
                       TreatmentPlanRepositoryType: TreatmentPlanManageable,
                       HormoneManagerType: HormoneLevelManageable>: View {
    
    let appStateManager: AppStateManagerType
    let appStartRepository: AppStartRepositoryType
    let injectionRepository: InjectionRepositoryType
    let labResultsRepository: LabResultsRepositoryType
    let treatmentPlanRepository: TreatmentPlanRepositoryType
    let hormoneManager: HormoneManagerType
    
    var body: some View {
        NavigationStack {
            List {
                OverviewContentView(appStateManager: appStateManager,
                                    appStartManager: appStartRepository,
                                    injectionRepository: injectionRepository,
                                    treatmentPlanRepository: treatmentPlanRepository,
                                    hormoneLevelManager: hormoneManager,
                                    labResultsRepository: labResultsRepository)
            }
            .navigationTitle(.navigationTitle)
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Overview"
    static let moodTitle: Self = "Mood"
}
