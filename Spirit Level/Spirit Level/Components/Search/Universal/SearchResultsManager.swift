import SwiftUI

// MARK: - SearchResultsManageable

protocol SearchResultsManageable: AnyObject, Observable {
    var items: [SearchItem] { get }
    var searchText: String { get set }
    var filteredItems: [SearchItem] { get }
}

// MARK: - SearchResultsManager

@Observable
final class SearchResultsManager: SearchResultsManageable {
    private(set) var items: [SearchItem]
    
    var searchText: String
    
    var filteredItems: [SearchItem] {
        guard !searchText.isEmpty else { return items }
        
        return items.filter {
            $0.label.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    init(items: [SearchItem], searchText: String = "") {
        self.items = items
        self.searchText = searchText
    }
}

extension SearchResultsManager {
    @MainActor
    static func getDefaultItems(appStateManager: AppStateRepository,
                                appStartRepository: AppStartRepository,
                                injectionRepository: InjectionRepository,
                                labResultsRepository: LabResultsRepository,
                                treatmentPlanRepository: TreatmentPlanRepository,
                                hormoneManager: HormoneLevelManager) -> [SearchItem] {
        [
            AppArea.getSearchItems(appStateManager: appStateManager,
                                   appStartRepository: appStartRepository,
                                   injectionRepository: injectionRepository,
                                   labResultsRepository: labResultsRepository,
                                   treatmentPlanRepository: treatmentPlanRepository,
                                   hormoneManager: hormoneManager),
            OverviewFeature.getSearchItems(hormoneManager: hormoneManager,
                                           injectionRepository: injectionRepository,
                                           treatmentPlanRepository: treatmentPlanRepository),
            StatisticsFeature.getSearchItems(injectionRepository: injectionRepository,
                                             labResultsRepository: labResultsRepository,
                                             hormoneLevelManager: hormoneManager),
            SettingsFeature.getSearchItems(treatmentPlanRepository: treatmentPlanRepository)
        ].flatMap { $0 }
    }
}
