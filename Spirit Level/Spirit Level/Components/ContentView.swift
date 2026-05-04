import SwiftUI

final class ContentViewModel<Dependencies: AppDependenciesProtocol, SearchManagerType: SearchResultsManageable> {
    var dependencies: Dependencies
    var searchManager: SearchManagerType

    init(dependencies: Dependencies, searchManager: SearchManagerType) {
        self.dependencies = dependencies
        self.searchManager = searchManager
    }
}

struct ContentView<DependenciesType: AppDependenciesProtocol,
                   SearchManagerType: SearchResultsManageable>: View {

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let viewModel: ContentViewModel<DependenciesType, SearchManagerType>

    init(dependencies: DependenciesType, searchManager: SearchManagerType) {
        self.viewModel = .init(dependencies: dependencies, searchManager: searchManager)
    }

    init(dependencies: DependenciesType) where SearchManagerType == SearchResultsManager {
        let defaultItems = SearchResultsManager.getDefaultItems(dependencies: dependencies)
        let searchResultsManager = SearchResultsManager(items: defaultItems)
        self.init(dependencies: dependencies, searchManager: searchResultsManager)
    }

    var body: some View {
        if horizontalSizeClass == .compact {
            TabViewLayout(dependencies: viewModel.dependencies, searchResultsManager: viewModel.searchManager)
        } else {
            SplitViewLayout(dependencies: viewModel.dependencies, searchManager: viewModel.searchManager)
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

// MARK: - Previews

#Preview("Light Mode") {
    ContentView(dependencies: Mocks.appDependencies)
        .environment(AppData())
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView(dependencies: Mocks.appDependencies)
        .environment(AppData())
        .preferredColorScheme(.dark)
}
