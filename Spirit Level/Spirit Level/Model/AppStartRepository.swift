import Foundation

// MARK: - AppStartManageable

@MainActor
protocol AppStartManageable: Observable, AnyObject {
    var firstAppStart: Date? { get set }
}

// MARK: - AppStartManager

@Observable
final class AppStartRepository: AppStartManageable {
    static let shared = AppStartRepository()
    
    var firstAppStart: Date? = UserDefaults.standard.object(forKey: "firstAppStart") as? Date {
        didSet { UserDefaults.standard.set(firstAppStart, forKey: "firstAppStart") }
    }

    private init() {}
}
