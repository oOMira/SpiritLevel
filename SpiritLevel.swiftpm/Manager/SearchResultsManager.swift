import SwiftUI

// MARK: - SearchResultsManagable

protocol SearchResultsManagable: AnyObject, Observable {
    var items: [SearchItem] { get }
    var searchText: String { get set }
    var filteredItems: [SearchItem] { get }
}

// MARK: - SearchResultsManager

@Observable
final class SearchResultsManager: SearchResultsManagable {
    private(set) var items: [SearchItem]
    
    var searchText: String
    
    var filteredItems: [SearchItem] {
        guard !searchText.isEmpty else { return items }
        
        return items.filter {
            $0.label.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    init(items: [SearchItem] = getDefaultItems(), searchText: String = "") {
        self.items = items
        self.searchText = searchText
    }
}

extension SearchResultsManager {
    static func getDefaultItems() -> [SearchItem] {
        let navigation: [SearchItem] = AppArea.allCases.compactMap { area in
            var configuration: NavigationConfiguration {
                switch area {
                case .overview:
                        .init { Overview(appStateManager: AppStateManager.shared) }
                case .statisitcs:
                        .init {StatisticsView() }
                case .settings:
                        .init { SettingsView() }
                }
            }
            return .navigation(feature: area, configuration: configuration)
        }
        
        let overview: [SearchItem] = OverviewFeature.allCases.compactMap { feature in
            switch feature {
            case .mood: return nil
            case .currentLevel: return nil
            case .nextInjection: return nil
            case .trend:
                let configuration = NavigationConfiguration.init(destination: {
                    TrendCellView(configurations: [
                        .init(name: "Level", trend: .up),
                        .init(name: "Consistency", trend: .down),
                    ])
                })
                return .overview(feature: feature, configuration: configuration)
            case .achivements: return nil
            }
        }

        return navigation + overview
    }
}

struct NavigationConfiguration {
    private let _destination: () -> AnyView
    
    init<V: View>(@ViewBuilder destination: @escaping () -> V) {
        self._destination = { AnyView(destination()) }
    }
    
    @ViewBuilder
    func getDestination() -> some View {
        _destination()
    }
}
