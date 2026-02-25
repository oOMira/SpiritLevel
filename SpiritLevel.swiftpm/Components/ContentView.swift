import SwiftUI
import Charts

struct ContentView<AppStateManagerType: AppStateManagable>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    var appStateManager: AppStateManagerType
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabViewLayout(appStateManager: appStateManager)
        } else {
            SplitViewLayout(appStateManager: appStateManager)
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

