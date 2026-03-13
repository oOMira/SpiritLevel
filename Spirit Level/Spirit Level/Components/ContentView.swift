import SwiftUI

struct ContentView<AppStateManagerType: AppStateManageable,
                   AppStartRepositoryType: AppStartManageable,
                   SearchResultsManagerType: SearchResultsManageable,
                   InjectionRepositoryType: InjectionManageable,
                   LabResultsManagerType: LabResultsManageable,
                   TreatmentPlanRepositoryType: TreatmentPlanManageable,
                   HormoneLevelManagerType: HormoneLevelManageable>: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let dependencies: AppDependencies<AppStateManagerType,
                                      AppStartRepositoryType,
                                      InjectionRepositoryType,
                                      LabResultsManagerType,
                                      TreatmentPlanRepositoryType,
                                      HormoneLevelManagerType>
    
    let searchResultsManager: SearchResultsManagerType
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabViewLayout(dependencies: dependencies,
                          searchResultsManager: searchResultsManager)
        } else {
            SplitViewLayout(dependencies: dependencies,
                            searchResultsManager: searchResultsManager)
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

