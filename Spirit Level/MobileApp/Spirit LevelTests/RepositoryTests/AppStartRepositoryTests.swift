import Testing
import SpiritLevelSharedTesting
import Foundation
@testable import Spirit_Level

@Suite("App Start Repository", .serialized, .tags(.userDefaults, .repository))
@MainActor
struct AppStartRepositoryTests {
    let userDefaults: UserDefaults
    let repo: AppStartRepository
    let suiteName: String

    init() {
        suiteName = UUID().uuidString
        userDefaults = UserDefaults(suiteName: suiteName)!
        repo = .init(userDefaults: userDefaults)
    }

    private func cleanup() {
        userDefaults.removePersistentDomain(forName: suiteName)
    }

    @Test("No app start saved")
    func testEmpty() {
        defer { cleanup() }
        let stored = userDefaults.object(forKey: "firstAppStart")
        #expect(stored == nil, "UserDefaults should not have an app start date stored initially")
        #expect(stored as? Date == repo.firstAppStart, "AppStartRepository should match stored value in UserDefaults when empty")
    }

    @Test("One app start")
    func testSet() {
        defer { cleanup() }
        let appStartDate = Date.distantPast
        repo.firstAppStart = appStartDate
        let stored = userDefaults.object(forKey: "firstAppStart") as? Date
        #expect(stored != nil, "UserDefaults should have an app start date stored after set")
        #expect(repo.firstAppStart == appStartDate, "AppStartRepository should return set date after set")
        #expect(repo.firstAppStart == stored, "AppStartRepository should match stored value in UserDefaults after set")
    }

    @Test("Save new app start date")
    func testUpdate() {
        defer { cleanup() }
        let oldAppStartDate = Date.distantPast
        let newAppStartDate = Date()
        repo.firstAppStart = oldAppStartDate
        repo.firstAppStart = newAppStartDate
        let stored = userDefaults.object(forKey: "firstAppStart") as? Date
        #expect(repo.firstAppStart != oldAppStartDate, "AppStartRepository shouold not return old date after update")
        #expect(repo.firstAppStart == newAppStartDate, "AppStartRepository should return new date after update")
        #expect(repo.firstAppStart == stored, "AppStartRepository should match UserDefaults value after update")
    }

    @Test("Save multiple new app start dates")
    func testMultipleUpdates() {
        defer { cleanup() }
        let oldAppStartDate = Date.now
        let firstNewAppStartDate = Calendar.current.date(byAdding: .day, value: -1, to: oldAppStartDate)!
        let secondNewAppStartDate = Date.distantPast
        repo.firstAppStart = oldAppStartDate
        repo.firstAppStart = firstNewAppStartDate
        repo.firstAppStart = secondNewAppStartDate
        let stored = userDefaults.object(forKey: "firstAppStart") as? Date
        #expect(repo.firstAppStart != oldAppStartDate, "AppStartRepository should not return old date after multiple updates")
        #expect(repo.firstAppStart != firstNewAppStartDate, "AppStartRepository should not return intermediate date after multiple updates")
        #expect(repo.firstAppStart == secondNewAppStartDate, "AppStartRepository should return latest date after multiple updates")
        #expect(repo.firstAppStart == stored, "AppStartRepository should match UserDefaults value after multiple updates")
    }
}
