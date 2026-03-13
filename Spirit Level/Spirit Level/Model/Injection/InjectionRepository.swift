import Foundation
import SwiftData

protocol InjectionManageable: Repository where ItemType == Injection {
    var last: ItemType? { get }
}

extension InjectionManageable {
    var last: ItemType? {
        allItems.max(by: { $0.date < $1.date })
    }
}

protocol HasInjectionRepository: AnyObject, Observable {
    associatedtype InjectionRepositoryType: InjectionManageable
    var injectionRepository: InjectionRepositoryType { get set }
}

// MARK: - InjectionRepository

@Observable
final class InjectionRepository: InjectionManageable, SwiftDataManageable {
    var observationTask: Task<Void, Never>?
    var modelContext: ModelContext
    var allItems: [Injection] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        observeModelContext()
        refresh()
    }
    
    @MainActor deinit { observationTask?.cancel() }
}

#if DEBUG
extension Mocks {
    static var injectionsRepository: InjectionRepository {
        return InjectionRepository(modelContext: modelContainer.mainContext)
    }
}
#endif
