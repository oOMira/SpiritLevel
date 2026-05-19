import SwiftData
import Foundation
import OSLog

public protocol Repository {
    associatedtype ItemType: PersistentModel
    var allItems: [ItemType] { get set }
    func add(item: ItemType) throws
    func delete(item: ItemType) throws
    func deleteAll() throws
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
    public var fetchDescriptor: FetchDescriptor<ItemType> { .init() }

    public func add(item: ItemType) throws {
        modelContext.insert(item)
        refresh()
    }

    public func delete(item: ItemType) throws {
        modelContext.delete(item)
        refresh()
    }

    public func fetchAll() throws -> [ItemType] {
        let descriptor = FetchDescriptor<ItemType>()
        return try modelContext.fetch(descriptor)
    }

    public func deleteAll() throws {
        allItems.forEach { modelContext.delete($0) }
        refresh()
    }

    public func saveIfNeeded() throws {
        guard modelContext.hasChanges else { return }
        try modelContext.save()
    }

    public func observeModelContext() {
        observationTask = Task { [weak self] in
            let notifications = NotificationCenter.default.notifications(
                named: ModelContext.didSave
            )

            for await _ in notifications {
                guard let self else { return }
                self.refresh()
            }
        }
    }

    @discardableResult
    public func refresh() -> [ItemType] {
        do {
            allItems = try modelContext.fetch(fetchDescriptor)
            return allItems
        } catch {
            Logger.data.error("Failed to refresh data: \(error)")
            return []
        }
    }
}
