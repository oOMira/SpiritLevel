import Testing
import Foundation
@testable import Spirit_Level

@MainActor
final class AppStartRepositoryTests {
    let userDefaults: UserDefaults
    let repo: AppStartRepository
    let suiteName: String

    init() {
        suiteName = UUID().uuidString
        userDefaults = UserDefaults(suiteName: suiteName)!
        repo = .init(userDefaults: userDefaults)
    }

    deinit {
        userDefaults.removePersistentDomain(forName: suiteName)
    }

    @Test func testEmpty() {
        let stored = userDefaults.object(forKey: "firstAppStart")
        #expect(stored == nil)
        #expect(stored as? Date == repo.firstAppStart)
    }

    @Test func testSet() {
        let appStartDate = Date.distantPast
        repo.firstAppStart = appStartDate
        let stored = userDefaults.object(forKey: "firstAppStart") as? Date
        #expect(stored != nil)
        #expect(repo.firstAppStart == appStartDate)
        #expect(repo.firstAppStart == stored)
    }

    @Test func testUpdate() {
        let oldAppStartDate = Date.distantPast
        let newAppStartDate = Date()
        repo.firstAppStart = oldAppStartDate
        repo.firstAppStart = newAppStartDate
        let stored = userDefaults.object(forKey: "firstAppStart") as? Date
        #expect(stored != nil)
        #expect(repo.firstAppStart == newAppStartDate)
        #expect(repo.firstAppStart == stored)
    }
}
