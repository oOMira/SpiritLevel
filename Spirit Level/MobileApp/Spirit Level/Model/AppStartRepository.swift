import Foundation
import OSLog
import SwiftData
import SpiritLevelShared

// MARK: - AppStartManageable

@MainActor
protocol AppStartManageable: Observable, AnyObject {
    var firstAppStart: Date? { get set }
}

protocol HasAppStartRepository: AnyObject, Observable {
    associatedtype AppStartRepo: AppStartManageable
    var appStartRepository: AppStartRepo { get set }
}

// MARK: - AppStartRepository

@Observable
final class AppStartRepository: AppStartManageable {
    private let modelContext: ModelContext
    private let appStart: AppStart

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.appStart = Self.getInModelContext(modelContext)
    }

    var firstAppStart: Date? {
        get { appStart.firstAppStart }
        set {
            appStart.firstAppStart = newValue
            save()
        }
    }

    private func save() {
        guard modelContext.hasChanges else { return }
        do {
            try modelContext.save()
        } catch {
            Logger.data.error("Failed to save app start: \(error)")
        }
    }

    private static func getInModelContext(_ modelContext: ModelContext) -> AppStart {
        do {
            if let existing = try modelContext.fetch(FetchDescriptor<AppStart>()).first {
                return existing
            }
        } catch {
            Logger.data.error("Failed to fetch app state: \(error)")
        }
        let new = AppStart()
        modelContext.insert(new)
        do {
            try modelContext.save()
        } catch {
            Logger.data.error("Failed to save new app state: \(error)")
        }
        return new
    }
}
