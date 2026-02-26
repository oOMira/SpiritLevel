// MARK: - AppArea+SearchItems

extension AppArea {
    static func getSearchItems(appStateManager: AppStateManager) -> [SearchItem] {
        Self.allCases.compactMap { area in
            var configuration: NavigationConfiguration {
                switch area {
                case .overview:
                        .init { Overview(appStateManager: appStateManager) }
                case .statisitcs:
                        .init {StatisticsView() }
                case .settings:
                        .init { SettingsView() }
                }
            }
            return .navigation(feature: area, configuration: configuration)
        }
    }
}

// MARK: - OverviewFeature+SearchItems

extension OverviewFeature {
    static func getSearchItems() -> [SearchItem] {
        Self.allCases.compactMap { feature in
            switch feature {
            case .mood:
                return .overview(feature: feature,
                                 configuration: .init(embedInList: true, destination: { MoodCellView() }))
            case .currentLevel:
                    return .overview(feature: feature,
                                     configuration: .init(embedInList: true, destination: { CurrentHormoneLevelCellView() }))
            case .nextInjection:
                return .overview(feature: feature, configuration: .init(embedInList: true, destination: { NextInjectionCellView() }))
            case .trend:
                let configuration = NavigationConfiguration.init(embedInList: true, destination: {
                    TrendCellView(configurations: [
                        .init(name: "Level", trend: .up),
                        .init(name: "Consistency", trend: .down),
                    ])
                })
                return .overview(feature: feature, configuration: configuration)
            case .achivements: return nil
            }
        }
    }
}

// MARK: - StatisticsFeature+SearchItems

extension StatisticsFeature {
    static func getSearchItems() -> [SearchItem] {
        Self.allCases.compactMap { feature in
            switch feature {
            case .graph:
                return .statistics(feature: feature,
                                   configuration: .init(embedInList: true, destination: { StatisticsCellView() }))
            case .injections:
                return nil
            case .labResults:
                return nil
            }
        }
    }
}

// MARK: - SettingsFeature+SearchItems

extension SettingsFeature {
    static func getSearchItems() -> [SearchItem] {
        Self.allCases.compactMap { feature in
            switch feature {
            case .deleteData:
                return nil
            case .plan:
                return nil
            case .support:
                return .settings(feature: feature,
                                 configuration: .init(destination: { SupportSection() }))
            case .data:
                return nil
            }
        }
    }
}
