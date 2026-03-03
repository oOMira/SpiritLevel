import Foundation
import SwiftData

protocol LabResultsManageable: SwiftDataManageable where ItemType == LabResult { }

// MARK: - InjectionRepository

@MainActor
@Observable
final class LabResultsRepository: LabResultsManageable {
    var observationTask: Task<Void, Never>?
    var modelContext: ModelContext
    var allItems: [LabResult] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        observeModelContext()
        refresh()
    }
}
