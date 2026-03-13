import Foundation

// MARK: - AppStateManageable

@MainActor
protocol AppStateManageable: Observable, AnyObject {
    var selectedAchievement: String? { get set }
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
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        selectedAchievement = userDefaults.string(forKey: "selectedAchievement")
        selectedTab = userDefaults.integer(forKey: "selectedTab")
        isMoodExpanded = userDefaults.bool(forKey: "moodExpanded")
        searchHistoryData = userDefaults.string(forKey: "searchHistory") ?? "[]"
    }
    
    var selectedAchievement: String? {
        didSet { userDefaults.set(selectedAchievement, forKey: "selectedAchievement") }
    }

    var selectedTab: Int {
        didSet { userDefaults.set(selectedTab, forKey: "selectedTab") }
    }

    var isMoodExpanded: Bool {
        didSet { userDefaults.set(isMoodExpanded, forKey: "moodExpanded") }
    }

    var searchHistoryData: String {
        didSet { userDefaults.set(searchHistoryData, forKey: "searchHistory") }
    }
}

#if DEBUG
extension Mocks {
    static var appState: AppStateRepository {
        let userDefaults = UserDefaults(suiteName: #file)
        userDefaults?.removePersistentDomain(forName: #file)
        return AppStateRepository(userDefaults: userDefaults!)
    }
}
#endif
