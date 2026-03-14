import Foundation
import SwiftData

protocol LabResultsManageable: SwiftDataManageable where ItemType == LabResult { }

protocol HasLabResultsRepository: AnyObject, Observable {
    associatedtype LabResultsRepositoryType: LabResultsManageable
    var labResultsRepository: LabResultsRepositoryType { get set }
}

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
