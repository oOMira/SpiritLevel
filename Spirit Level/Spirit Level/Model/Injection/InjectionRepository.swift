import Foundation
import SwiftData

protocol InjectionManageable: SwiftDataManageable where ItemType == Injection { }

protocol HasInjectionRepository: AnyObject, Observable {
    associatedtype InjectionRepositoryType: InjectionManageable
    var injectionRepository: InjectionRepositoryType { get set }
}

// MARK: - InjectionRepository

@MainActor
@Observable
final class InjectionRepository: InjectionManageable {
    var observationTask: Task<Void, Never>?
    var modelContext: ModelContext
    var allItems: [Injection] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        observeModelContext()
        refresh()
    }
}
