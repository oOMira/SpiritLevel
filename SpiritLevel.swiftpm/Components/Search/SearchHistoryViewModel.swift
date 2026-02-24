import SwiftUI

final class SearchHistoryViewModel: ObservableObject {
    @ObservedObject private var appState = AppStateManager.shared
    
    var searchHistory: [String] {
        (try? JSONDecoder().decode([String].self, from: Data(appState.searchHistoryData.utf8))) ?? []
    }

    func addToHistory(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        var history = searchHistory
        history.removeAll { $0 == trimmed }
        history.insert(trimmed, at: 0)
        history = Array(history.prefix(Int.maxHistoryItems))
        if let data = try? JSONEncoder().encode(history) {
            appState.searchHistoryData = String(data: data, encoding: .utf8) ?? "[]"
        }
    }

    func clearHistory() {
        appState.searchHistoryData = "[]"
    }
}

private extension Int {
    static let maxHistoryItems: Self = 10
}
