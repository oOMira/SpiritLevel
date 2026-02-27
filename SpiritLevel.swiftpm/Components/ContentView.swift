import SwiftUI
import Charts

struct ContentView<AppStateManagerType: AppStateManagable,
                   SearchResultsManagerType: SearchResultsManagable,
                   InjectionRepositoryType: InjectionManagable>: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private let appStateManager: AppStateManagerType
    private let searchResultsManager: SearchResultsManagerType
    private let injectionRepository: InjectionRepositoryType
    
    init(appStateManager: AppStateManagerType,
         searchResultsManager: SearchResultsManagerType,
         injectionRepository: InjectionRepositoryType) {
        self.appStateManager = appStateManager
        self.searchResultsManager = searchResultsManager
        self.injectionRepository = injectionRepository
    }
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabViewLayout(appStateManager: appStateManager,
                          searchResultsManager: searchResultsManager,
                          injectionReposetory: injectionRepository)
        } else {
            SplitViewLayout(appStateManager: appStateManager,
                            searchReultsManger: searchResultsManager,
                            injectionReposetory: injectionRepository)
        }
    }
}


// MARK: - Constants

@MainActor
extension LocalizedStringKey {
    static let searchTitle: Self = "Search"
}

extension String {
    static let magnifyingglass: Self = "magnifyingglass"
}

