import Foundation

// MARK: - AppStartManageable

@MainActor
protocol AppStartManageable: Observable, AnyObject {
    var firstAppStart: Date? { get set }
}

protocol HasAppStartRepository: AnyObject, Observable {
    associatedtype AppStartRepo: AppStartManageable
    var appStartRepository: AppStartRepo { get set }
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
