import SwiftUI
    
@Observable
final class SearchResultsManager: SearchResultsManagable {
    private(set) var items: [SearchItem] = [
        .navigation(feature: .overview),
        .navigation(feature: .settings)
    ]
    var searchText: String = ""
    
    var filteredItems: [SearchItem] {
        guard !searchText.isEmpty else { return items }
        
        return items.filter {
            $0.label.localizedCaseInsensitiveContains(searchText)
        }
    }

}
