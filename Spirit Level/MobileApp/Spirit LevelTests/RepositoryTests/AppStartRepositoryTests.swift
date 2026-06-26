import Testing
import SpiritLevelSharedTesting
import Foundation
@testable import Spirit_Level

@Suite("App Start Repository", .serialized, .tags(.swiftData, .repository))
@MainActor
struct AppStartRepositoryTests: ModelContextMockable {
    let repo: AppStartRepository

    init() {
        let modelContext = Self.getMockModelContext(for: AppStart.self)
        repo = .init(modelContext: modelContext)
    }

    @Test("No app start saved")
    func testEmpty() {
        #expect(repo.firstAppStart == nil, "AppStartRepository should default firstAppStart to nil")
    }

    @Test("One app start")
    func testSet() {
        let appStartDate = Date.distantPast
        repo.firstAppStart = appStartDate
        #expect(repo.firstAppStart == appStartDate, "AppStartRepository should return set date after set")
    }

    @Test("Save new app start date")
    func testUpdate() {
        let oldAppStartDate = Date.distantPast
        let newAppStartDate = Date()
        repo.firstAppStart = oldAppStartDate
        repo.firstAppStart = newAppStartDate
        #expect(repo.firstAppStart != oldAppStartDate, "AppStartRepository should not return old date after update")
        #expect(repo.firstAppStart == newAppStartDate, "AppStartRepository should return new date after update")
    }

    @Test("Save multiple new app start dates")
    func testMultipleUpdates() throws {
        let oldAppStartDate = Date.now
        let firstNewAppStartDate = try #require(Calendar.current.date(byAdding: .day, value: -1, to: oldAppStartDate))
        let secondNewAppStartDate = Date.distantPast
        repo.firstAppStart = oldAppStartDate
        repo.firstAppStart = firstNewAppStartDate
        repo.firstAppStart = secondNewAppStartDate
        #expect(repo.firstAppStart != oldAppStartDate, "AppStartRepository should not return old date after multiple updates")
        #expect(repo.firstAppStart != firstNewAppStartDate, "AppStartRepository should not return intermediate date after multiple updates")
        #expect(repo.firstAppStart == secondNewAppStartDate, "AppStartRepository should return latest date after multiple updates")
    }

    @Test("Repository persists single AppStart instance")
    func testSingleInstance() throws {
        let modelContext = Self.getMockModelContext(for: AppStart.self)
        let firstRepo = AppStartRepository(modelContext: modelContext)
        let date = Date.distantPast
        firstRepo.firstAppStart = date

        let secondRepo = AppStartRepository(modelContext: modelContext)
        #expect(secondRepo.firstAppStart == date, "AppStartRepository should hydrate from existing AppStart instance")
    }
}
