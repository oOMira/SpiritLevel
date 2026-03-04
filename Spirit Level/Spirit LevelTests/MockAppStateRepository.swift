@testable import Spirit_Level
import Foundation

// MARK: - Mock AppStateRepository

@MainActor
final class MockAppStateRepository: AppStateManageable {
    var selectedTab: Int
    var isMoodExpanded: Bool
    var searchHistoryData: String
    
    init(selectedTab: Int = 0, isMoodExpanded: Bool = false, searchHistoryData: String = "[]") {
        self.selectedTab = selectedTab
        self.isMoodExpanded = isMoodExpanded
        self.searchHistoryData = searchHistoryData
    }
}
