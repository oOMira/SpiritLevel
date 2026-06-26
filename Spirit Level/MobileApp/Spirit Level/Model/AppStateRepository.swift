import Foundation
import OSLog
import SwiftData
import SpiritLevelShared

// MARK: - AppStateManageable

@MainActor
protocol AppStateManageable: Observable, AnyObject {
    var selectedAchievement: String? { get set }
    var selectedTab: Int { get set }
    var isMoodExpanded: Bool { get set }
    var searchHistoryData: String { get set }
}

protocol HasAppStateManager: AnyObject, Observable {
    associatedtype AppStateMgr: AppStateManageable
    var appStateManager: AppStateMgr { get set }
}

// MARK: - AppStateRepository

@Observable
final class AppStateRepository: AppStateManageable {
    private let modelContext: ModelContext
    private let appState: AppState

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.appState = Self.getInModelContext(modelContext)
    }

    var selectedAchievement: String? {
        get { appState.selectedAchievement }
        set {
            appState.selectedAchievement = newValue
            save()
        }
    }

    var selectedTab: Int {
        get { appState.selectedTab }
        set {
            appState.selectedTab = newValue
            save()
        }
    }

    var isMoodExpanded: Bool {
        get { appState.isMoodExpanded }
        set {
            appState.isMoodExpanded = newValue
            save()
        }
    }

    var searchHistoryData: String {
        get { appState.searchHistoryData }
        set {
            appState.searchHistoryData = newValue
            save()
        }
    }

    private func save() {
        guard modelContext.hasChanges else { return }
        do {
            try modelContext.save()
        } catch {
            Logger.data.error("Failed to save app state: \(error)")
        }
    }

    private static func getInModelContext(_ modelContext: ModelContext) -> AppState {
        do {
            if let existing = try modelContext.fetch(FetchDescriptor<AppState>()).first {
                return existing
            }
        } catch {
            Logger.data.error("Failed to fetch app state: \(error)")
        }
        let new = AppState()
        modelContext.insert(new)
        do {
            try modelContext.save()
        } catch {
            Logger.data.error("Failed to save new app state: \(error)")
        }
        return new
    }
}
