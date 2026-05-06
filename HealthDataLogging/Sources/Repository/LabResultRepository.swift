import Foundation
import SwiftData

public protocol LabResultsManageable: Repository where ItemType == LabResult { }

public protocol HasLabResultsRepository: AnyObject, Observable {
    associatedtype LabResultsRepo: LabResultsManageable
    var labResultsRepository: LabResultsRepo { get set }
}

@Observable
public final class LabResultsRepository: @MainActor LabResultsManageable, SwiftDataManageable {
    public var observationTask: Task<Void, Never>?
    public var modelContext: ModelContext
    public var allItems: [LabResult] = []

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        observeModelContext()
        refresh()
    }

    @MainActor deinit { observationTask?.cancel() }
}
