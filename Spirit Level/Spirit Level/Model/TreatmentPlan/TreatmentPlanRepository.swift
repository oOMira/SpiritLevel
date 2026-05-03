import Foundation
import SwiftData

protocol TreatmentPlanManageable: Repository where ItemType == TreatmentPlan {
    func getLatest(till date: Date) -> ItemType?
    func getLatest() -> ItemType?
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
    
    func getLatest(till date: Date) -> TreatmentPlan? {
        allItems
            .filter { $0.firstInjectionDate <= date }
            .max(by: { $0.firstInjectionDate < $1.firstInjectionDate })
    }
    
    func getLatest() -> TreatmentPlan? {
        getLatest(till: .now)
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
