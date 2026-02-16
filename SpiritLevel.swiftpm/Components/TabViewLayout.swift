import SwiftUI

struct TabViewLayout<AppStateManagerType: AppStateManageable,
                     AppStartRepositoryType: AppStartManageable,
                     SearchResultsManagerType: SearchResultsManageable,
                     InjectionRepositoryType: InjectionManageable,
                     LabResultsRepositoryType: LabResultsManageable,
                     TreatmentPlanRepositoryType: TreatmentPlanManageable,
                     HormoneLevelManagerType: HormoneLevelManageable>: View {
    
    @Bindable var appStateManager: AppStateManagerType
    let appStartRepository: AppStartRepositoryType
    let searchResultsManager: SearchResultsManagerType
    let injectionRepository: InjectionRepositoryType
    let labResultsRepository: LabResultsRepositoryType
    let treatmentPlanRepository: TreatmentPlanRepositoryType
    let hormoneLevelManager: HormoneLevelManagerType
    
    var body: some View {
        TabView(selection: $appStateManager.selectedTab) {
            let enumeratedAppAreas = Array(AppArea.allCases.enumerated())
            ForEach(enumeratedAppAreas, id: \.offset) { index, area in
                Tab(area.label,
                    systemImage: area.systemImageName,
                    value: index) {
                    NavigationStack {
                        switch area {
                        case .overview: Overview(appStateManager: appStateManager,
                                                 appStartRepository: appStartRepository,
                                                 injectionRepository: injectionRepository,
                                                 labResultsRepository: labResultsRepository,
                                                 treatmentPlanRepository: treatmentPlanRepository,
                                                 hormoneManager: hormoneLevelManager)
                        case .statistics: StatisticsView(injectionRepository: injectionRepository,
                                                         labResultsRepository: labResultsRepository)
                        case .settings: SettingsView(appStartRepository: appStartRepository,
                                                     appStateRepository: appStateManager,
                                                     injectionRepository: injectionRepository,
                                                     labResultsRepository: labResultsRepository,
                                                     treatmentPlanRepository: treatmentPlanRepository,
                                                     hormoneLevelManager: hormoneLevelManager)
                        }
                    }
                }
            }
            Tab(.searchTitle, systemImage: .magnifyingglass, value: -1, role: .search) {
                SearchView(appStateManager: appStateManager,
                           appStartRepository: appStartRepository,
                           searchHistoryManager: .init(appStateManager: appStateManager),
                           injectionRepository: injectionRepository,
                           labResultsRepository: labResultsRepository,
                           treatmentPlanRepository: treatmentPlanRepository,
                           hormoneLevelManager: hormoneLevelManager,
                           searchResultsManager: searchResultsManager)
            }
        }
    }
}

