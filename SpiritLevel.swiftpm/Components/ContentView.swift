import SwiftUI
import Charts

struct ContentView<AppStateManagerType: AppStateManagable,
                   SearchResultsManagerType: SearchResultsManagable>: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var appStateManager: AppStateManagerType
    private var searchResultsManager: SearchResultsManagerType
    
    init(appStateManager: AppStateManagerType, searchResultsManager: SearchResultsManagerType) {
        self.appStateManager = appStateManager
        self.searchResultsManager = searchResultsManager
    }
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabViewLayout(appStateManager: appStateManager,
                          searchResultsManager: searchResultsManager)
        } else {
            SplitViewLayout(appStateManager: appStateManager,
                            searchReultsManger: searchResultsManager)
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

