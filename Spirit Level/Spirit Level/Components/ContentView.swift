import SwiftUI

struct ContentView<AppStateManagerType: AppStateManageable,
                   AppStartRepositoryType: AppStartManageable,
                   SearchResultsManagerType: SearchResultsManageable,
                   InjectionRepositoryType: InjectionManageable,
                   LabResultsManagerType: LabResultsManageable,
                   TreatmentPlanRepositoryType: TreatmentPlanManageable,
                   HormoneLevelManagerType: HormoneLevelManageable>: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let appStateManager: AppStateManagerType
    let appStartRepository: AppStartRepositoryType
    let searchResultsManager: SearchResultsManagerType
    let injectionRepository: InjectionRepositoryType
    let labResultsRepository: LabResultsManagerType
    let treatmentPlanRepository: TreatmentPlanRepositoryType
    let hormoneLevelManager: HormoneLevelManagerType
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabViewLayout(appStateManager: appStateManager,
                          appStartRepository: appStartRepository,
                          searchResultsManager: searchResultsManager,
                          injectionRepository: injectionRepository,
                          labResultsRepository: labResultsRepository,
                          treatmentPlanRepository: treatmentPlanRepository,
                          hormoneLevelManager: hormoneLevelManager)
        } else {
            SplitViewLayout(appStateManager: appStateManager,
                            appStartRepository: appStartRepository,
                            searchResultsManager: searchResultsManager,
                            injectionRepository: injectionRepository,
                            labResultsRepository: labResultsRepository,
                            treatmentPlanRepository: treatmentPlanRepository,
                            hormoneLevelManager: hormoneLevelManager,
                            searchHistoryManager: .init(appStateManager: appStateManager))
        }
    }
}


// MARK: - Constants

extension LocalizedStringResource {
    static let searchTitle: Self = "Search"
}

extension String {
    static let magnifyingglass: Self = "magnifyingglass"
}

