import SwiftUI
import Charts

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject private var appState = AppStateManager.shared
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabViewLayout()
        } else {
            SplitViewLayout()
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

