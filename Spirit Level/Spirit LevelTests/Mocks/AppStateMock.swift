import Foundation
@testable import Spirit_Level

@Observable
@MainActor
class AppStateMock: AppStateManageable {
    init(
        selectedAchievement: String? = nil,
        selectedTab: Int = 0,
        isMoodExpanded: Bool = false,
        searchHistoryData: String = "[]"
    ) {
        self.selectedAchievement = selectedAchievement
        self.selectedTab = selectedTab
        self.isMoodExpanded = isMoodExpanded
        self.searchHistoryData = searchHistoryData
    }

    var selectedAchievement: String?
    var selectedTab: Int
    var isMoodExpanded: Bool
    var searchHistoryData: String
}
