import Foundation
import SwiftData

protocol LabResultsManageable: Repository where ItemType == LabResult { }

protocol HasLabResultsRepository: AnyObject, Observable {
    associatedtype LabResultsRepo: LabResultsManageable
    var labResultsRepository: LabResultsRepo { get set }
}

// MARK: - LabResultsRepository

@Observable
final class LabResultsRepository: LabResultsManageable, SwiftDataManageable {
    var observationTask: Task<Void, Never>?
    var modelContext: ModelContext
    var allItems: [LabResult] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        observeModelContext()
        refresh()
    }

    @MainActor deinit { observationTask?.cancel() }
}

#if DEBUG
extension Mocks {
    static var labResultsRepository: LabResultsRepository {
        return LabResultsRepository(modelContext: modelContainer.mainContext)
    }
}
#endif
