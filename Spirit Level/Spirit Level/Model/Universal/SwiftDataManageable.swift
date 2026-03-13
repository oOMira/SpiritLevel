import SwiftData
import Foundation
import OSLog

protocol Repository {
    associatedtype ItemType: PersistentModel
    var allItems: [ItemType] { get set }
    func add(item: ItemType) throws
    func delete(item: ItemType) throws
    func deleteAll() throws
}

@MainActor
protocol SwiftDataManageable: AnyObject {
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
    var fetchDescriptor: FetchDescriptor<ItemType> { .init() }
    
    func add(item: ItemType) throws {
        modelContext.insert(item)
        refresh()
    }
    
    func delete(item: ItemType) throws {
        modelContext.delete(item)
        refresh()
    }
    
    func fetchAll() throws -> [ItemType] {
        let descriptor = FetchDescriptor<ItemType>()
        return try modelContext.fetch(descriptor)
    }
    
    func deleteAll() throws {
        allItems.forEach { modelContext.delete($0) }
        refresh()
    }
    
    func saveIfNeeded() throws {
        guard modelContext.hasChanges else { return }
        try modelContext.save()
    }
    
    func observeModelContext() {
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

    // TODO: add error
    @discardableResult
    func refresh() -> [ItemType] {
        do {
            allItems = try modelContext.fetch(fetchDescriptor)
            return allItems
        } catch {
            Logger.data.error("Failed to refresh data: \(error)")
            return []
        }
    }
}
