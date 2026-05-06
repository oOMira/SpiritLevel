import Testing
import SpiritLevelSharedTesting
import Foundation
@testable import Spirit_Level

@Suite("App State Repository", .serialized, .tags(.userDefaults, .repository))
@MainActor
struct AppStateRepositoryTests {
    let userDefaults: UserDefaults
    let repo: AppStateRepository
    let suiteName: String

    init() {
        suiteName = UUID().uuidString
        userDefaults = UserDefaults(suiteName: suiteName)!
        repo = .init(userDefaults: userDefaults)
    }

    private func cleanup() {
        userDefaults.removePersistentDomain(forName: suiteName)
    }

    @Test("No app state saved")
    func testEmpty() {
        defer { cleanup() }
        validateUserDefaultsMatchRepo()
    }

    @Test("Set app state configuration")
    func testSet() {
        defer { cleanup() }
        let expanded = true
        let searchHistoryData = "[a, b, c, d, f, j, k]"
        let selectedAchievement = "4"
        let selectedTab = 2

        repo.isMoodExpanded = expanded
        repo.searchHistoryData = searchHistoryData
        repo.selectedAchievement = selectedAchievement
        repo.selectedTab = selectedTab
        validateUserDefaultsMatchRepo()

        #expect(repo.isMoodExpanded == expanded, "AppStateRepository should return set mood expansion state after set")
        #expect(repo.searchHistoryData == searchHistoryData, "AppStateRepository should return set search history after set")
        #expect(repo.selectedAchievement == selectedAchievement, "AppStateRepository should return set selected achievement after set")
        #expect(repo.selectedTab == selectedTab, "AppStateRepository should return set selected tab after set")
    }

    @Test("update app state configuration")
    func testUpdate() {
        defer { cleanup() }
        let oldExpanded = true
        let oldSearchHistoryData = "[a, b, c, d, f, j, k]"
        let oldSelectedAchievement = "4"
        let oldSelectedTab = 2

        let newExpanded = false
        let newSearchHistoryData = "[b, c, d, f, j, k]"
        let newSelectedAchievement = "3"
        let newSelectedTab = 1

        repo.isMoodExpanded = oldExpanded
        repo.searchHistoryData = oldSearchHistoryData
        repo.selectedAchievement = oldSelectedAchievement
        repo.selectedTab = oldSelectedTab

        repo.isMoodExpanded = newExpanded
        repo.searchHistoryData = newSearchHistoryData
        repo.selectedAchievement = newSelectedAchievement
        repo.selectedTab = newSelectedTab

        validateUserDefaultsMatchRepo()

        #expect(repo.isMoodExpanded == newExpanded, "AppStateRepository should return new mood expansion state after update")
        #expect(repo.searchHistoryData == newSearchHistoryData, "AppStateRepository should return new search history after update")
        #expect(repo.selectedAchievement == newSelectedAchievement, "AppStateRepository should return new selected achievement after update")
        #expect(repo.selectedTab == newSelectedTab, "AppStateRepository should return new selected tab after update")
    }

    @Test("Multiple updates for app state configuration")
    func testMultipleUpdates() {
        defer { cleanup() }
        let oldExpanded = true
        let oldSearchHistoryData = "[a, b, c, d, f, j, k]"
        let oldSelectedAchievement = "4"
        let oldSelectedTab = 2

        let intermediateSearchHistoryData = "[d, f, j, k]"

        let newExpanded = false
        let newSearchHistoryData = "[b, c, d, f, j, k]"
        let newSelectedAchievement = "3"
        let newSelectedTab = 1

        repo.isMoodExpanded = oldExpanded
        repo.searchHistoryData = oldSearchHistoryData
        repo.selectedAchievement = oldSelectedAchievement
        repo.selectedTab = oldSelectedTab

        repo.searchHistoryData = intermediateSearchHistoryData

        repo.isMoodExpanded = newExpanded
        repo.searchHistoryData = newSearchHistoryData
        repo.selectedAchievement = newSelectedAchievement
        repo.selectedTab = newSelectedTab

        validateUserDefaultsMatchRepo()

        #expect(repo.searchHistoryData != intermediateSearchHistoryData, "AppStateRepository should not return intermediate search history after multiple updates")

        #expect(repo.isMoodExpanded == newExpanded, "AppStateRepository should return latest mood expansion state after multiple updates")
        #expect(repo.searchHistoryData == newSearchHistoryData, "AppStateRepository should return latest search history after multiple updates")
        #expect(repo.selectedAchievement == newSelectedAchievement, "AppStateRepository should return latest selected achievement after multiple updates")
        #expect(repo.selectedTab == newSelectedTab, "AppStateRepository should return latest selected tab after multiple updates")
    }
}

// MARK: - Helper

extension AppStateRepositoryTests {
    private func validateUserDefaultsMatchRepo() {
        let userDefaultsMood = userDefaults.bool(forKey: "moodExpanded")
        let selectedAchievement = userDefaults.string(forKey: "selectedAchievement")
        let selectedTab = userDefaults.integer(forKey: "selectedTab")
        let searchHistoryData = userDefaults.string(forKey: "searchHistory") ?? "[]"
        #expect(userDefaultsMood == repo.isMoodExpanded, "AppStateRepository should match stored mood expansion state in UserDefaults")
        #expect(searchHistoryData == repo.searchHistoryData, "AppStateRepository should match stored search history in UserDefaults")
        #expect(selectedTab == repo.selectedTab, "AppStateRepository should match stored selected tab in UserDefaults")
        #expect(selectedAchievement == repo.selectedAchievement, "AppStateRepository should match stored selected achievement in UserDefaults")
    }
}
