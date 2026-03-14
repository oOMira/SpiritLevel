import Foundation
import SwiftData

@MainActor
protocol TreatmentPlanManageable: SwiftDataManageable where ItemType == TreatmentPlan {
    var latest: ItemType? { get }
}

protocol HasTreatmentPlanRepository: AnyObject, Observable {
    associatedtype TreatmentPlanRepositoryType: TreatmentPlanManageable
    var treatmentPlanRepository: TreatmentPlanRepositoryType { get set }
}

// MARK: - InjectionRepository

@MainActor
@Observable
final class TreatmentPlanRepository: TreatmentPlanManageable {
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
}
