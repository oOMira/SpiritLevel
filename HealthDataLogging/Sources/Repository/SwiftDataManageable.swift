import SwiftData
import Foundation
// Used for notification name
import CoreData
import OSLog
import SpiritLevelShared

public protocol Repository {
    associatedtype ItemType: PersistentModel
    var allItems: [ItemType] { get set }
    func add(item: ItemType) throws
    func delete(item: ItemType) throws
    func deleteAll() throws
    @discardableResult @MainActor func refresh() -> [ItemType]
}

@MainActor
public protocol SwiftDataManageable: AnyObject {
    associatedtype ItemType: PersistentModel
    var modelContext: ModelContext { get }
    var allItems: [ItemType] { get set }
    var observationTask: Task<Void, Never>? { get set }

    func add(item: ItemType) throws

    func delete(item: ItemType) throws
    func deleteAll() throws
    func fetchAll() throws -> [ItemType]
    func observeModelContext()
}

extension SwiftDataManageable {
    public func add(item: ItemType) throws {
        modelContext.insert(item)
        try saveIfNeeded()
        refresh()
    }

    public func delete(item: ItemType) throws {
        modelContext.delete(item)
        try saveIfNeeded()
        refresh()
    }

    public func fetchAll() throws -> [ItemType] {
        try modelContext.fetch(FetchDescriptor<ItemType>())
    }

    public func deleteAll() throws {
        allItems.forEach { modelContext.delete($0) }
        try saveIfNeeded()
        refresh()
    }

    public func saveIfNeeded() throws {
        guard modelContext.hasChanges else { return }
        try modelContext.save()
    }

    @MainActor
    public func observeModelContext() {
        observationTask?.cancel()

        observationTask = Task { [weak self] in
            let notifications = NotificationCenter.default.notifications(
                named: ModelContext.didSave
            )

            for await _ in notifications {
                guard !Task.isCancelled else { return }
                self?.refresh()
            }
        }
    }
    
    @discardableResult
    public func refresh() -> [ItemType] {
        do {
            allItems = try fetchAll()
            return allItems
        } catch {
            Logger.data.error("Failed to refresh data: \(error)")
            return []
        }
    }
}
