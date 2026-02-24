import SwiftUI

final class AppStateManager: ObservableObject {
    // Singleton instance
    static let shared = AppStateManager()
    
    // MARK: - App Storage Properties

    @AppStorage("selectedTab") var selectedTab: Int = 0
    @AppStorage("moodExpanded") var isMoodExpanded: Bool = true
    @AppStorage("searchHistory") var searchHistoryData: String = "[]"
    
    // MARK: - Initialization
    
    private init() {
        // Private initializer to enforce singleton pattern
    }
}
