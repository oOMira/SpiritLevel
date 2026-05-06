import Testing
import SpiritLevelSharedTesting
import Foundation
@testable import Spirit_Level

@Suite("Achievements Test")
@MainActor
struct AchievementsTests {

    @Test("Identifiable")
    func testIdentifiable() {
        let ids = Achievement.allCases.map { $0.id }
        #expect(Set(ids).count == ids.count, "Achievement IDs should be unique")
    }

    @Test("Achievement Name", .tags(.resources), arguments: Achievement.allCases)
    func testAchievementName(_ achievement: Achievement) {
        #expect(!String(localized: achievement.name).isEmpty)
    }

    @Test("Achievement Description", .tags(.resources), arguments: Achievement.allCases)
    func testAchievementDescription(_ achievement: Achievement) {
        #expect(!String(localized: achievement.description).isEmpty)
    }

    @Test("Achievement Image Description", .tags(.resources), arguments: Achievement.allCases)
    func testAchievementImageDescription(_ achievement: Achievement) {
        #expect(!String(localized: achievement.imageDescription).isEmpty)
    }

    @Test("Achievement Image", .tags(.resources), arguments: Achievement.allCases)
    func testAchievementImageName(_ achievement: Achievement) {
        #expect(!achievement.imageName.isEmpty, "\(achievement) image name should not be empty")
        #expect(achievement.image != nil, "\(achievement) image should not be empty")
    }
}
