import Testing
import Foundation
@testable import Spirit_Level

@MainActor
final class AppStateRepositoryTests {
    let userDefaults: UserDefaults
    let repo: AppStateRepository
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
        validateUserDefaultsMatchRepo()
    }

    @Test func testSet() {
        let expanded = true
        let searchHistoryData = "[a, b, c, d, f, j, k]"
        let selectedAchievement = "4"
        let selectedTab = 2
        
        repo.isMoodExpanded = expanded
        repo.searchHistoryData = searchHistoryData
        repo.selectedAchievement = selectedAchievement
        repo.selectedTab = selectedTab
        validateUserDefaultsMatchRepo()
        
        #expect(repo.isMoodExpanded == expanded)
        #expect(repo.searchHistoryData == searchHistoryData)
        #expect(repo.selectedAchievement == selectedAchievement)
        #expect(repo.selectedTab == selectedTab)
    }
    
    @Test func testUpdate() {
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
        
        #expect(repo.isMoodExpanded == newExpanded)
        #expect(repo.searchHistoryData == newSearchHistoryData)
        #expect(repo.selectedAchievement == newSelectedAchievement)
        #expect(repo.selectedTab == newSelectedTab)
    }
}

// MARK: - Helper

extension AppStateRepositoryTests {
    private func validateUserDefaultsMatchRepo() {
        let userDefaultsMood = userDefaults.bool(forKey: "moodExpanded")
        let selectedAchievement = userDefaults.string(forKey: "selectedAchievement")
        let selectedTab = userDefaults.integer(forKey: "selectedTab")
        let searchHistoryData = userDefaults.string(forKey: "searchHistory") ?? "[]"
        #expect(userDefaultsMood == repo.isMoodExpanded)
        #expect(searchHistoryData == repo.searchHistoryData)
        #expect(selectedTab == repo.selectedTab)
        #expect(selectedAchievement == repo.selectedAchievement)
    }
}
