@testable import Spirit_Level
import Foundation

// MARK: - Mock AppStartRepository

@MainActor
final class MockAppStartRepository: AppStartManageable, Mockable {
    var firstAppStart: Date?
    
    init(firstAppStart: Date? = nil) {
        self.firstAppStart = firstAppStart
    }
    
    static var one: MockAppStartRepository {
        MockAppStartRepository(firstAppStart: Date())
    }
    
    static var tone: MockAppStartRepository {
        MockAppStartRepository(firstAppStart: Date().addingTimeInterval(-60 * 24 * 60 * 60))
    }
    
    static var none: MockAppStartRepository {
        MockAppStartRepository(firstAppStart: nil)
    }
}
