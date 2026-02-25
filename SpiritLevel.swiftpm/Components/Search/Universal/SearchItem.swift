import SwiftUI

enum SearchItem {
    case navigation(feature: AppArea, configuration: NavigationConfiguration)
    case overview(feature: OverviewFeature, configuration: NavigationConfiguration)
    case statics(feaature: StatisticsFeature, configuration: NavigationConfiguration)
    case settings(feature: SettingsFeature, configuration: NavigationConfiguration)
}

extension SearchItem: SearchableItem {
    init?(rawValue: String) { nil }
    
    private var value: (item: any SearchableItem, configuration: NavigationConfiguration) {
        switch self {
        case let .navigation(feature, configuration): (feature, configuration)
        case let .overview(feature, configuration): (feature, configuration)
        case let .statics(feature, configuration): (feature, configuration)
        case let .settings(feature, configuration): (feature, configuration)
        }
    }
    
    var feature: any SearchableItem { value.item }
    var configuration: NavigationConfiguration { value.configuration }

    var rawValue: String { feature.rawValue }
    var label: String { feature.label }
    var systemImageName: String { feature.systemImageName }
}
