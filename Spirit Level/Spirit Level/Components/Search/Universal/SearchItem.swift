import SwiftUI

enum SearchItem {
    case navigation(NavigationConfiguration<AppArea>)
    case overview(NavigationConfiguration<OverviewFeature>)
    case statistics(NavigationConfiguration<StatisticsFeature>)
    case settings(NavigationConfiguration<SettingsFeature>)
}

// MARK: - SearchItem+SearchableItem

// TODO: fix raw values
extension SearchItem: SearchableItem {
    init?(rawValue: String) { nil }
    var rawValue: String { feature.rawValue }
    
    var configuration: any NavigationConfigurationProvidable {
        switch self {
        case let .navigation(configuration): configuration
        case let .overview(configuration): configuration
        case let .statistics(configuration): configuration
        case let .settings(configuration): configuration
        }
    }
    
    var feature: any SearchableItem { configuration.feature }

    var itemType: ItemType { feature.itemType }
    var label: String { feature.label }
    var systemImageName: String { feature.systemImageName }
}

// MARK: - NavigationConfigurationProvidable

protocol NavigationConfigurationProvidable {
    associatedtype FeatureType: SearchableItem
    var feature: FeatureType { get }
    @ViewBuilder func getDestination() -> AnyView
}

// MARK: - SearchItem+NavigationConfiguration

struct NavigationConfiguration<FeatureType: SearchableItem>: NavigationConfigurationProvidable {
    let feature: FeatureType
    private let _destination: () -> AnyView
    
    init<V: View>(feature: FeatureType, @ViewBuilder destination: @escaping () -> V) {
        var embedInList: Bool {
            switch feature.itemType {
            case .content: return true
            case .navigation: return false
            }
        }

        self.feature = feature
        self._destination = {
            if embedInList {
                AnyView(
                    List { destination() }
                        .navigationTitle(feature.label)
                )
            } else {
                AnyView(destination())
            }
        }
    }
    
    @ViewBuilder
    func getDestination() -> AnyView {
        _destination()
    }
}
