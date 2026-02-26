import Foundation

// MARK: - AppStartManagable

protocol AppStartManagable: Observable, AnyObject {
    var firstAppStart: Date? { get set }
}

// MARK: - AppStartManager

@Observable
final class AppStartRepository: AppStartManagable {
    @MainActor static let shared = AppStartRepository()
    
    var firstAppStart: Date? = UserDefaults.standard.object(forKey: "firstAppStart") as? Date {
        didSet { UserDefaults.standard.set(firstAppStart, forKey: "firstAppStart") }
    }

    private init() {}
}
