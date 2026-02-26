// MARK: - AppArea+SearchItems

extension AppArea {
    static func getSearchItems(appStateManager: AppStateRepository) -> [SearchItem] {
        Self.allCases.compactMap { area in
            var configuration: NavigationConfiguration<AppArea> {
                switch area {
                case .overview:
                        .init(feature: area) { Overview(appStateManager: appStateManager) }
                case .statisitcs:
                        .init(feature: area) { StatisticsView() }
                case .settings:
                        .init(feature: area) { SettingsView() }
                }
            }
            return .navigation(configuration)
        }
    }
}

// MARK: - OverviewFeature+SearchItems

extension OverviewFeature {
    static func getSearchItems() -> [SearchItem] {
        Self.allCases.compactMap { feature in
            switch feature {
            case .mood:
                return .overview(.init(feature: feature, destination: { MoodCellView() }))
            case .currentLevel:
                    return .overview(.init(feature: feature, destination: { CurrentHormoneLevelCellView() }))
            case .nextInjection:
                return .overview(.init(feature: feature, destination: { NextInjectionCellView() }))
            case .trend:
                let configuration = NavigationConfiguration.init(feature: feature, destination: {
                    TrendCellView(configurations: [
                        .init(name: "Level", trend: .up),
                        .init(name: "Consistency", trend: .down),
                    ])
                })
                return .overview(configuration)
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
                return .statistics(.init(feature: feature, destination: { StatisticsCellView() }))
            case .injections:
                return .statistics(.init(feature: feature, destination: { InjectionsCellView() }))
            case .labResults:
                return .statistics(.init(feature: feature, destination: { LabResultsCellView() }))
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
                return .settings(.init(feature: feature, destination: { TreatmentPlanCellView() }))
            case .support:
                return .settings(.init(feature: feature, destination: { SupportCellView() }))
            case .data:
                return .settings(.init(feature: feature, destination: { UsedDataCellView() }))
            }
        }
    }
}
