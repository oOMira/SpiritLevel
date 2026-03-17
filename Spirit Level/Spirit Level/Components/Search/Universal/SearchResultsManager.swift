import SwiftUI

// MARK: - SearchResultsManageable

protocol SearchResultsManageable: AnyObject, Observable {
    var items: [SearchItem] { get }
    var searchText: String { get set }
    var filteredItems: [SearchItem] { get }
}

protocol HasSearchResultsManager: AnyObject, Observable {
    associatedtype SearchResultsManagerType: SearchResultsManageable
    var searchResultsManager: SearchResultsManagerType { get set }
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
    typealias SearchResultsDependencies = HasAppStateManager & HasAppStartRepository & HasInjectionRepository & HasLabResultsRepository & HasTreatmentPlanRepository & HasHormoneLevelManager
    
    @MainActor
    static func getDefaultItems<Dependencies: SearchResultsDependencies>(dependencies: Dependencies) -> [SearchItem] {
        [
            OverviewFeature.getSearchItems(dependencies: dependencies),
            AppArea.getSearchItems(dependencies: dependencies),
            StatisticsFeature.getSearchItems(dependencies: dependencies),
            SettingsFeature.getSearchItems(dependencies: dependencies)
        ].flatMap { $0 }
    }
}
