import Foundation
import SwiftData

// MARK: - InjectionManagable

protocol InjectionManagable: SwiftDataManagable where ItemType == Injection { }

// MARK: - InjectionRepository

@Observable
final class InjectionRepository: InjectionManagable {    
    var modelContext: ModelContext
    var allItems: [Injection] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
}
