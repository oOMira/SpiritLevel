import Foundation

// MARK: - AppStartManageable

@MainActor
protocol AppStartManageable: Observable, AnyObject {
    var firstAppStart: Date? { get set }
}

protocol HasAppStartRepository: AnyObject, Observable {
    associatedtype AppStartRepositoryType: AppStartManageable
    var appStartRepository: AppStartRepositoryType { get set }
}

// MARK: - AppStartManager

@Observable
final class AppStartRepository: AppStartManageable {
    static let shared = AppStartRepository()
    
    private let userDefaults: UserDefaults
    
    var firstAppStart: Date? {
        didSet { userDefaults.set(firstAppStart, forKey: "firstAppStart") }
    }
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.firstAppStart = userDefaults.object(forKey: "firstAppStart") as? Date
    }
}

#if DEBUG
extension Mocks {
    static var appStart: AppStartRepository {
        let userDefaults = UserDefaults(suiteName: #file)
        userDefaults?.removePersistentDomain(forName: #file)
        return AppStartRepository(userDefaults: userDefaults!)
    }
}
#endif
