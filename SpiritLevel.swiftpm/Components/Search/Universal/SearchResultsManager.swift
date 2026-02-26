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
    
    init(items: [SearchItem], searchText: String = "") {
        self.items = items
        self.searchText = searchText
    }
}

extension SearchResultsManager {
    static func getDefaultItems(appStateManager: AppStateRepository) -> [SearchItem] {
        [
            AppArea.getSearchItems(appStateManager: appStateManager),
            OverviewFeature.getSearchItems(),
            StatisticsFeature.getSearchItems(),
            SettingsFeature.getSearchItems()
        ].flatMap { $0 }
    }
}
