import Foundation

protocol SearchResultsManagable: Observable {
    var items: [SearchItem] { get }
    var searchText: String { get set }
    var filteredItems: [SearchItem] { get }
}
