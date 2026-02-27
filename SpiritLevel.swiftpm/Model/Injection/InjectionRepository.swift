import Foundation
import SwiftData
import Combine

// MARK: - InjectionManagable

protocol InjectionManagable: SwiftDataManagable where ItemType == Injection { }

// MARK: - InjectionRepository

@Observable
final class InjectionRepository: InjectionManagable {
    var cancellables = Set<AnyCancellable>()
    var modelContext: ModelContext
    var allItems: [Injection] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        observeModelContext()
        refresh()
    }
}
