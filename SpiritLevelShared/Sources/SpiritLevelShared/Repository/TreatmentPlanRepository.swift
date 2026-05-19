import Foundation
import SwiftData

public protocol TreatmentPlanManageable: Repository where ItemType == TreatmentPlan {
    func getLatest(until date: Date) -> ItemType?
    func getLatest() -> ItemType?
}

public protocol HasTreatmentPlanRepository: AnyObject, Observable {
    associatedtype TreatmentPlanRepo: TreatmentPlanManageable
    var treatmentPlanRepository: TreatmentPlanRepo { get set }
}

@Observable
public final class TreatmentPlanRepository: @MainActor TreatmentPlanManageable, SwiftDataManageable {
    public var observationTask: Task<Void, Never>?
    public var modelContext: ModelContext
    public var allItems: [TreatmentPlan] = []

    public func getLatest(until date: Date) -> TreatmentPlan? {
        allItems
            .filter { $0.firstInjectionDate <= date }
            .max(by: { $0.firstInjectionDate < $1.firstInjectionDate })
    }

    public func getLatest() -> TreatmentPlan? {
        getLatest(until: .now)
    }

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        observeModelContext()
        refresh()
    }

    @MainActor deinit { observationTask?.cancel() }
}
