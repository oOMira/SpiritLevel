import SwiftData

protocol SwiftDataManagable {
    associatedtype ItemType: PersistentModel
    var modelContext: ModelContext { get }
    var allItems: [ItemType] { get }
    
    func add(item: ItemType) throws
    
    func delete(item: ItemType) throws
    func fetchAll() throws -> [ItemType]
}
    
extension SwiftDataManagable {
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
}
