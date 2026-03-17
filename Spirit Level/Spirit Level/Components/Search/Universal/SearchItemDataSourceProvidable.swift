import SwiftUI

// MARK: - AppArea+SearchItems

extension AppArea {
    typealias GetSearchItemsDependencies = HasAppStateManager & HasAppStartRepository & HasInjectionRepository & HasLabResultsRepository & HasTreatmentPlanRepository & HasHormoneLevelManager
    
    static func getSearchItems<Dependencies: GetSearchItemsDependencies>(dependencies: Dependencies) -> [SearchItem] {
        
        Self.allCases.compactMap { area in
            var configuration: NavigationConfiguration<AppArea>? {
                switch area {
                    // TODO: Fix overview
                case .overview: return nil
                case .statistics:
                    return .init(feature: area) { StatisticsView(dependencies: dependencies) }
                case .settings:
                    return .init(feature: area) { SettingsView(dependencies: dependencies) }
                }
            }
            guard let configuration else { return nil }
            return .navigation(configuration)
            
        }
    }
}

// MARK: - OverviewFeature+SearchItems

// TODO: - fix search

extension OverviewFeature {
    typealias GetSearchItemsDependencies = HasHormoneLevelManager & HasInjectionRepository & HasTreatmentPlanRepository
    
    @MainActor
    static func getSearchItems<Dependencies: GetSearchItemsDependencies>(dependencies: Dependencies) -> [SearchItem] {
        Self.allCases.compactMap { feature in
            switch feature {
            case .reminders: return nil
            case .mood: return .overview(.init(feature: feature, destination: {
                MoodCellView(dependencies: dependencies)
            }))
            case .currentLevel: return .overview(.init(feature: feature, destination: {
                CurrentHormoneLevelCellView(viewModel: .init(dependencies: dependencies))
            }))
            case .nextInjection: return .overview(.init(feature: feature, destination: {
                NextInjectionCellView(viewModel: .init(dependencies: dependencies))
            }))
            case .achievements: return nil
            }
        }
    }
}

// MARK: - StatisticsFeature+SearchItems

extension StatisticsFeature {
    typealias GetSearchItemsDependencies = HasInjectionRepository & HasLabResultsRepository & HasHormoneLevelManager
    
    @MainActor
    static func getSearchItems<Dependencies: GetSearchItemsDependencies>(dependencies: Dependencies) -> [SearchItem] {
        Self.allCases.compactMap { feature in
            var configuration: NavigationConfiguration<StatisticsFeature>? {
                switch feature {
                case .chart: return nil
                case .injections:
                    return .init(feature: feature) { InjectionsCellView(injectionRepository: dependencies.injectionRepository) }
                case .labResults:
                    return .init(feature: feature) { LabResultsCellView(labResultsRepository: dependencies.labResultsRepository) }
                case .history:
                    return nil
                case .trends:
                    return nil
                }
            }
            guard let configuration else { return nil }
            return .statistics(configuration)
        }
    }
}

// MARK: - SettingsFeature+SearchItems

extension SettingsFeature {
    typealias GetSearchItemsDependencies = HasTreatmentPlanRepository
    
    static func getSearchItems<Dependencies: GetSearchItemsDependencies>(dependencies: Dependencies) -> [SearchItem] {
        
        Self.allCases.compactMap { feature in
            var configuration: NavigationConfiguration<SettingsFeature>? {
                switch feature {
                case .deleteData: return nil
                case .plan:
                    return .init(feature: feature) { TreatmentPlanCellView(treatmentPlanRepository: dependencies.treatmentPlanRepository) }
                case .support:
                    return .init(feature: feature) { SupportCellView() }
                case .data:
                    return .init(feature: feature) { UsedResourcesView() }
                }
            }
            guard let configuration else { return nil }
            return .settings(configuration)
            
        }
    }
}
