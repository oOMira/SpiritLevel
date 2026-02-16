import SwiftData
import Foundation

@MainActor
protocol SwiftDataManageable: AnyObject {
    associatedtype ItemType: PersistentModel
    var modelContext: ModelContext { get }
    var allItems: [ItemType] { get set }
    // TODO: Check if explicit cancelation is needed
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
        try modelContext.save()
    }
    
    func delete(item: ItemType) throws {
        modelContext.delete(item)
        try modelContext.save()
    }
    
    func fetchAll() throws -> [ItemType] {
        let descriptor = FetchDescriptor<ItemType>()
        return try modelContext.fetch(descriptor)
    }
    
    func deleteAll() throws {
        allItems.forEach { modelContext.delete($0) }
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

    @discardableResult
    func refresh() -> [ItemType] {
        do {
            allItems = try modelContext.fetch(fetchDescriptor)
            return allItems
        } catch {
            print("Failed to refresh data: \(error)")
            return []
        }
    }
}
