import SwiftUI

@MainActor
@Observable
final class SearchHistoryManager<AppStateManagerType: AppStateManageable> {
    var appStateManager: AppStateManagerType
    
    init(appStateManager: AppStateManagerType) {
        self.appStateManager = appStateManager
    }
    
    var searchHistory: [String] {
        (try? JSONDecoder().decode([String].self, from: Data(appStateManager.searchHistoryData.utf8))) ?? []
    }

    func addToHistory(_ query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        var history = searchHistory
        history.removeAll { $0 == query }
        history.insert(query, at: 0)
        history = Array(history.prefix(Int.maxHistoryItems))
        if let data = try? JSONEncoder().encode(history) {
            appStateManager.searchHistoryData = String(data: data, encoding: .utf8) ?? "[]"
        }
    }

    func clearHistory() {
        appStateManager.searchHistoryData = "[]"
    }
}

private extension Int {
    static let maxHistoryItems: Self = 10
}
