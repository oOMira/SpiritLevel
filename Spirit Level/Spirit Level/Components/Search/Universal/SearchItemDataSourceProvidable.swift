import SwiftUI

// MARK: - AppArea+SearchItems

extension AppArea {
    static func getSearchItems(appStateManager: AppStateRepository,
                               appStartRepository: AppStartRepository,
                               injectionRepository: InjectionRepository,
                               labResultsRepository: LabResultsRepository,
                               treatmentPlanRepository: TreatmentPlanRepository,
                               hormoneManager: HormoneLevelManager) -> [SearchItem] {
        
        let appDependencies = AppDependencies(appStateManager: appStateManager,
                                              appStartManger: appStartRepository,
                                              injectionRepository: injectionRepository,
                                              treatmentPlanRepository: treatmentPlanRepository,
                                              hormoneLevelManager: hormoneManager,
                                              labResultsRepository: labResultsRepository)

        return Self.allCases.compactMap { area in
            var configuration: NavigationConfiguration<AppArea> {
                switch area {
                case .overview:
                        .init(feature: area) { Overview(dependencies: appDependencies) }
                case .statistics:
                        .init(feature: area) { StatisticsView(injectionRepository: injectionRepository,
                                                              labResultsRepository: labResultsRepository,
                                                              hormoneLevelManager: hormoneManager) }
                case .settings:
                        .init(feature: area) { SettingsView(appStartRepository: appStartRepository,
                                                            appStateRepository: appStateManager,
                                                            injectionRepository: injectionRepository,
                                                            labResultsRepository: labResultsRepository,
                                                            treatmentPlanRepository: treatmentPlanRepository,
                                                            hormoneLevelManager: hormoneManager) }
                }
            }
            return .navigation(configuration)
        }
    }
}

// MARK: - OverviewFeature+SearchItems

extension OverviewFeature {
    @MainActor
    static func getSearchItems(hormoneManager: HormoneLevelManager,
                               injectionRepository: InjectionRepository,
                               treatmentPlanRepository: TreatmentPlanRepository) -> [SearchItem] {
        Self.allCases.compactMap { feature in
            switch feature {
            case .reminders: return nil
            case .mood:
                return .overview(.init(feature: feature, destination: {
                    MoodCellView(injectionRepository: injectionRepository,
                                 hormoneManager: hormoneManager)
                }))
            case .currentLevel:
                    return .overview(.init(feature: feature, destination: { 
                        CurrentHormoneLevelCellView(injectionRepository: injectionRepository,
                                                   hormoneManager: hormoneManager) 
                    }))
            case .nextInjection:
                return .overview(.init(feature: feature, destination: { 
                    NextInjectionCellView(treatmentRepository: treatmentPlanRepository,
                                        injectionRepository: injectionRepository) 
                }))
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
            case .chart:
                return .statistics(.init(feature: feature,
                                         destination: {
                    CurrentHormoneLevelCellView(injectionRepository: injectionRepository,
                                                       hormoneManager: hormoneLevelManager) }))
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
