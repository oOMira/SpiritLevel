import Foundation
import SwiftData

@Model
final class AppState {
    var selectedAchievement: String?
    var selectedTab: Int = 0
    var isMoodExpanded: Bool = true
    var searchHistoryData: String = "[]"

    init(selectedAchievement: String? = nil,
         selectedTab: Int = 0,
         isMoodExpanded: Bool = true,
         searchHistoryData: String = "[]") {
        self.selectedAchievement = selectedAchievement
        self.selectedTab = selectedTab
        self.isMoodExpanded = isMoodExpanded
        self.searchHistoryData = searchHistoryData
    }
}
