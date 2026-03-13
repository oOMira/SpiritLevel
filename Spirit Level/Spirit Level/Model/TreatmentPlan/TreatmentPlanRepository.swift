import Foundation
import SwiftData

protocol TreatmentPlanManageable: Repository where ItemType == TreatmentPlan {
    var latest: ItemType? { get }
}

protocol HasTreatmentPlanRepository: AnyObject, Observable {
    associatedtype TreatmentPlanRepositoryType: TreatmentPlanManageable
    var treatmentPlanRepository: TreatmentPlanRepositoryType { get set }
}

// MARK: - TreatmentPlanRepository

@Observable
final class TreatmentPlanRepository: TreatmentPlanManageable, SwiftDataManageable {
    var observationTask: Task<Void, Never>?
    var modelContext: ModelContext
    var allItems: [TreatmentPlan] = []
    
    var latest: TreatmentPlan? {
        allItems.max(by: { $0.firstInjectionDate < $1.firstInjectionDate })
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        observeModelContext()
        refresh()
    }
    
    @MainActor deinit { observationTask?.cancel() }
}

#if DEBUG
extension Mocks {
    static var treatmentPlanRepository: TreatmentPlanRepository {
        return TreatmentPlanRepository(modelContext: modelContainer.mainContext)
    }
}
#endif
