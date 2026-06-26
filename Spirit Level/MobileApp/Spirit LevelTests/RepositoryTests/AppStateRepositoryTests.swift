import Testing
import SpiritLevelSharedTesting
import Foundation
@testable import Spirit_Level

@Suite("App State Repository", .serialized, .tags(.swiftData, .repository))
@MainActor
struct AppStateRepositoryTests: ModelContextMockable {
    let repo: AppStateRepository

    init() {
        let modelContext = Self.getMockModelContext(for: AppState.self)
        repo = .init(modelContext: modelContext)
    }

    @Test("Defaults when no app state saved")
    func testEmpty() {
        #expect(repo.selectedAchievement == nil, "AppStateRepository should default selectedAchievement to nil")
        #expect(repo.selectedTab == 0, "AppStateRepository should default selectedTab to 0")
        #expect(repo.isMoodExpanded == true, "AppStateRepository should default isMoodExpanded to true")
        #expect(repo.searchHistoryData == "[]", "AppStateRepository should default searchHistoryData to empty array")
    }

    @Test("Set app state configuration")
    func testSet() {
        let expanded = true
        let searchHistoryData = "[a, b, c, d, f, j, k]"
        let selectedAchievement = "4"
        let selectedTab = 2

        repo.isMoodExpanded = expanded
        repo.searchHistoryData = searchHistoryData
        repo.selectedAchievement = selectedAchievement
        repo.selectedTab = selectedTab

        #expect(repo.isMoodExpanded == expanded, "AppStateRepository should return set mood expansion state after set")
        #expect(repo.searchHistoryData == searchHistoryData, "AppStateRepository should return set search history after set")
        #expect(repo.selectedAchievement == selectedAchievement, "AppStateRepository should return set selected achievement after set")
        #expect(repo.selectedTab == selectedTab, "AppStateRepository should return set selected tab after set")
    }

    @Test("Update app state configuration")
    func testUpdate() {
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

        #expect(repo.isMoodExpanded == newExpanded, "AppStateRepository should return new mood expansion state after update")
        #expect(repo.searchHistoryData == newSearchHistoryData, "AppStateRepository should return new search history after update")
        #expect(repo.selectedAchievement == newSelectedAchievement, "AppStateRepository should return new selected achievement after update")
        #expect(repo.selectedTab == newSelectedTab, "AppStateRepository should return new selected tab after update")
    }

    @Test("Multiple updates for app state configuration")
    func testMultipleUpdates() {
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

        #expect(repo.searchHistoryData != intermediateSearchHistoryData, "AppStateRepository should not return intermediate search history after multiple updates")

        #expect(repo.isMoodExpanded == newExpanded, "AppStateRepository should return latest mood expansion state after multiple updates")
        #expect(repo.searchHistoryData == newSearchHistoryData, "AppStateRepository should return latest search history after multiple updates")
        #expect(repo.selectedAchievement == newSelectedAchievement, "AppStateRepository should return latest selected achievement after multiple updates")
        #expect(repo.selectedTab == newSelectedTab, "AppStateRepository should return latest selected tab after multiple updates")
    }

    @Test("Repository persists single AppState instance")
    func testSingleInstance() throws {
        let modelContext = Self.getMockModelContext(for: AppState.self)
        let firstRepo = AppStateRepository(modelContext: modelContext)
        firstRepo.selectedTab = 3
        firstRepo.selectedAchievement = "7"

        let secondRepo = AppStateRepository(modelContext: modelContext)
        #expect(secondRepo.selectedTab == 3, "AppStateRepository should hydrate from existing AppState instance")
        #expect(secondRepo.selectedAchievement == "7", "AppStateRepository should hydrate from existing AppState instance")
    }
}
