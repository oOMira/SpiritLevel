import Foundation
@testable import Spirit_Level

class TreatmentPlanMock: TreatmentPlanManageable {
    init(allItems: [TreatmentPlan] = []) {
        self.allItems = allItems
    }

    var allItems: [TreatmentPlan]

    func getLatest(till date: Date) -> TreatmentPlan? {
        allItems
            .filter { $0.firstInjectionDate.start <= date.start }
            .max(by: { $0.firstInjectionDate.start < $1.firstInjectionDate.start })
    }

    func getLatest() -> TreatmentPlan? {
        getLatest(till: .now)
    }

    func add(item: TreatmentPlan) throws {
        allItems.append(item)
    }

    func delete(item: TreatmentPlan) throws {
        allItems.removeAll { $0 == item }
    }

    func deleteAll() throws {
        allItems = []
    }
}

extension TreatmentPlanMock {
    static var one: TreatmentPlanMock {
        let item = TreatmentPlan(name: "Default", ester: .enanthate, frequency: 7, dosage: 1.0, firstInjectionDate: .distantPast)
        return .init(allItems: [item])
    }

    static var tone: TreatmentPlanMock {
        let item1 = TreatmentPlan(name: "Plan A", ester: .enanthate, frequency: 7, dosage: 1.0, firstInjectionDate: .distantPast)
        let item2 = TreatmentPlan(name: "Plan B", ester: .valerate, frequency: 5, dosage: 2.0, firstInjectionDate: .init())
        let item3 = TreatmentPlan(name: "Plan C", ester: .enanthate, frequency: 14, dosage: 3.0, firstInjectionDate: .distantFuture)
        return .init(allItems: [item1, item2, item3])
    }

    static var none: TreatmentPlanMock { .init() }
}
