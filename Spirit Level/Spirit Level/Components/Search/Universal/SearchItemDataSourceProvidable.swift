import SwiftUI

// MARK: - AppArea+SearchItems

extension AppArea {
    static func getSearchItems(appStateManager: AppStateRepository,
                               appStartRepository: AppStartRepository,
                               injectionRepository: InjectionRepository,
                               labResultsRepository: LabResultsRepository,
                               treatmentPlanRepository: TreatmentPlanRepository,
                               hormoneManager: HormoneLevelManager) -> [SearchItem] {
    
        Self.allCases.compactMap { area in
            var configuration: NavigationConfiguration<AppArea>? {
                switch area {
                // TODO: Fix overview
                case .overview: return nil
                case .statistics:
                        return .init(feature: area) { StatisticsView(injectionRepository: injectionRepository,
                                                              labResultsRepository: labResultsRepository,
                                                              hormoneLevelManager: hormoneManager) }
                case .settings:
                        return .init(feature: area) { SettingsView(appStartRepository: appStartRepository,
                                                            appStateRepository: appStateManager,
                                                            injectionRepository: injectionRepository,
                                                            labResultsRepository: labResultsRepository,
                                                            treatmentPlanRepository: treatmentPlanRepository,
                                                            hormoneLevelManager: hormoneManager) }
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
        @MainActor
        static func getSearchItems(hormoneManager: HormoneLevelManager,
                                   injectionRepository: InjectionRepository,
                                   treatmentPlanRepository: TreatmentPlanRepository) -> [SearchItem] {
            Self.allCases.compactMap { feature in
                switch feature {
                case .reminders: return nil
                case .mood: return nil
                case .currentLevel: return nil
                case .nextInjection: return nil
                case .achievements: return nil
                }
            }
        }
    }
    
    // MARK: - StatisticsFeature+SearchItems
    
    extension StatisticsFeature {
        @MainActor
        static func getSearchItems(injectionRepository: InjectionRepository,
                                   labResultsRepository: LabResultsRepository,
                                   hormoneLevelManager: HormoneLevelManager) -> [SearchItem] {
            Self.allCases.compactMap { feature in
                switch feature {
                case .chart: return nil
                case .injections:
                    return .statistics(.init(feature: feature,
                                             destination: { InjectionsCellView(injectionRepository: injectionRepository) } ))
                case .labResults:
                    return .statistics(.init(feature: feature,
                                             destination: { LabResultsCellView(labResultsRepository: labResultsRepository) }))
                }
            }
        }
    }
    
    // MARK: - SettingsFeature+SearchItems
    
    extension SettingsFeature {
        static func getSearchItems(treatmentPlanRepository: TreatmentPlanRepository) -> [SearchItem] {
            Self.allCases.compactMap { feature in
                switch feature {
                case .deleteData:
                    return nil
                case .plan:
                    return .settings(.init(feature: feature, destination: {
                        TreatmentPlanCellView(treatmentPlanRepository: treatmentPlanRepository)
                    }))
                case .support:
                    return .settings(.init(feature: feature, destination: { SupportCellView() }))
                case .data:
                    return .settings(.init(feature: feature, destination: { UsedResourcesView() }))
                }
            }
        }
    }
