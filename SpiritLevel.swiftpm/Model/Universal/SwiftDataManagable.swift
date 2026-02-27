import SwiftData
import Foundation
import Combine

protocol SwiftDataManagable: AnyObject {
    associatedtype ItemType: PersistentModel
    var modelContext: ModelContext { get }
    var allItems: [ItemType] { get set }
    var cancellables: Set<AnyCancellable> { get set }
    
    func add(item: ItemType) throws
    
    func delete(item: ItemType) throws
    func fetchAll() throws -> [ItemType]
    func observeModelContext()
}

extension SwiftDataManagable {
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
    
    func observeModelContext() {
        NotificationCenter.default
            .publisher(for: ModelContext.didSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.refresh()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.refresh()
            }
            .store(in: &cancellables)
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
