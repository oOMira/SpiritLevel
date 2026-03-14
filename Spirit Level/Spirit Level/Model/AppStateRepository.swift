import Foundation

// MARK: - AppStateManageable

@MainActor
protocol AppStateManageable: Observable, AnyObject {
    var selectedTab: Int { get set }
    var isMoodExpanded: Bool { get set }
    var searchHistoryData: String { get set }
}

protocol HasAppStateManager: AnyObject, Observable {
    associatedtype AppStateManagerType: AppStateManageable
    var appStateManager: AppStateManagerType { get set }
}

// MARK: - AppStateManager

@Observable
final class AppStateRepository: AppStateManageable {
    static let shared = AppStateRepository()

    var selectedTab: Int = UserDefaults.standard.integer(forKey: "selectedTab") {
        didSet { UserDefaults.standard.set(selectedTab, forKey: "selectedTab") }
    }

    var isMoodExpanded: Bool = UserDefaults.standard.bool(forKey: "moodExpanded") {
        didSet { UserDefaults.standard.set(isMoodExpanded, forKey: "moodExpanded") }
    }

    var searchHistoryData: String = UserDefaults.standard.string(forKey: "searchHistory") ?? "[]" {
        didSet { UserDefaults.standard.set(searchHistoryData, forKey: "searchHistory") }
    }

    private init() {}
}
