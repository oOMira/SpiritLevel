import SwiftUI

struct ContentView<DependenciesType: AppDependenciesProtocol>: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let dependencies: DependenciesType
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabViewLayout(dependencies: dependencies)
        } else {
            SplitViewLayout(dependencies: dependencies)
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

