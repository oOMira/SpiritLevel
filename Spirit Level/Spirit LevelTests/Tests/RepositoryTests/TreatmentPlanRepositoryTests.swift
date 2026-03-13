import Testing
import Foundation
import SwiftData
@testable import Spirit_Level

@MainActor
struct TreatmentPlanRepositoryTests: ModelContextMockable {
    let repo = TreatmentPlanRepository(modelContext: Self.getMockModelContext(for: TreatmentPlan.self))
    
    @Test func testEmpty() async throws {
        #expect(repo.allItems.count == 0)
    }

    @Test func testAddInjection() async throws {
        let name = "treatmentPlan"
        let ester =  Ester.valerate
        let frequency = 3
        let dosage = 3.0
        let date = Date()
        let plan = TreatmentPlan(name: name,
                                 ester: ester,
                                 frequency: frequency,
                                 dosage: dosage,
                                 firstInjectionDate: date)
        try repo.add(item: plan)
        #expect(repo.allItems.count == 1)
        #expect(repo.allItems.first?.name == name)
        #expect(repo.allItems.first?.ester == ester)
        #expect(repo.allItems.first?.frequency == frequency)
        #expect(repo.allItems.first?.dosage == dosage)
        #expect(repo.allItems.first?.firstInjectionDate == date)
    }

    @Test func testDeleteInjection() async throws {
        let plan = getBurnerPlan()
        try repo.add(item: plan)
        try repo.delete(item: plan)
        #expect(repo.allItems.count == 0)
    }

    @Test func testDeleteAll() throws {
        let plan1 = getBurnerPlan()
        let plan2 = getBurnerPlan()
        try repo.add(item: plan1)
        try repo.add(item: plan2)
        #expect(repo.allItems.count == 2)
        try repo.deleteAll()
        #expect(repo.allItems.count == 0)
    }
}

extension TreatmentPlanRepositoryTests {
    func getBurnerPlan() -> TreatmentPlan {
        TreatmentPlan(name: "My Plan", ester: .enanthate, frequency: 7, dosage: 3.0, firstInjectionDate: .init())
    }
}
