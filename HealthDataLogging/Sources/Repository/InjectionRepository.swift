import Foundation
import SwiftData

public protocol InjectionManageable: Repository where ItemType == Injection {
    var last: ItemType? { get }
}

extension InjectionManageable {
    public var last: ItemType? {
        allItems.max(by: { $0.date < $1.date })
    }
}

public protocol HasInjectionRepository: AnyObject, Observable {
    associatedtype InjectionRepo: InjectionManageable
    var injectionRepository: InjectionRepo { get set }
}

@Observable
public final class InjectionRepository: @MainActor InjectionManageable, SwiftDataManageable {
    public var observationTask: Task<Void, Never>?
    public var modelContext: ModelContext
    public var allItems: [Injection] = []

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        observeModelContext()
        refresh()
    }

    @MainActor deinit { observationTask?.cancel() }
}
