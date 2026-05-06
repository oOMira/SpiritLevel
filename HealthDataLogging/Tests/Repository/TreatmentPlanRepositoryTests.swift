import Testing
import HealthDataLogging
import SpiritLevelSharedTesting
import Foundation
import SwiftData

@Suite("Treatment Plan Repository", .tags(.swiftData, .repository, .treatmentPlans))
@MainActor
struct TreatmentPlanRepositoryTests: ModelContextMockable {
    let repo = TreatmentPlanRepository(modelContext: Self.getMockModelContext(for: TreatmentPlan.self))

    @Test("No treatment plan set up")
    func testEmpty() async throws {
        #expect(repo.allItems.count == 0, "TreatmentPlanRepository should return no treatment plans when empty")
    }

    @Test("Set up treatment plan")
    func testAddTreatmentPlan() async throws {
        let name = "treatmentPlan"
        let ester = Ester.valerate
        let frequency = 3
        let dosage = 3.0
        let date = Date()
        let plan = TreatmentPlan(name: name,
                                 ester: ester,
                                 frequency: frequency,
                                 dosage: dosage,
                                 firstInjectionDate: date)
        try repo.add(item: plan)
        #expect(repo.allItems.count == 1, "TreatmentPlanRepository should return one treatment plan after add")
        #expect(repo.allItems.first?.name == name, "TreatmentPlanRepository should return set name after add")
        #expect(repo.allItems.first?.ester == ester, "TreatmentPlanRepository should return set ester after add")
        #expect(repo.allItems.first?.frequency == frequency, "TreatmentPlanRepository should return set frequency after add")
        #expect(repo.allItems.first?.dosage == dosage, "TreatmentPlanRepository should return set dosage after add")
        #expect(repo.allItems.first?.firstInjectionDate == date, "TreatmentPlanRepository should return set first injection date after add")
    }

    @Test("Set up many treatment plans")
    func testAddManyTreatmentPlans() throws {
        let firstStoredDate = Date.now
        let secondStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -1, to: firstStoredDate))
        let thirdStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -2, to: firstStoredDate))
        let fourthStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -3, to: firstStoredDate))
        let fifthStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -4, to: firstStoredDate))
        let sixthStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -5, to: firstStoredDate))
        let plans = [
            TreatmentPlan(name: "Plan A", ester: .valerate, frequency: 3, dosage: 2.0, firstInjectionDate: firstStoredDate),
            TreatmentPlan(name: "Plan B", ester: .enanthate, frequency: 7, dosage: 4.0, firstInjectionDate: secondStoredDate),
            TreatmentPlan(name: "Plan C", ester: .valerate, frequency: 14, dosage: 5.0, firstInjectionDate: thirdStoredDate),
            TreatmentPlan(name: "Plan D", ester: .enanthate, frequency: 5, dosage: 3.0, firstInjectionDate: fourthStoredDate),
            TreatmentPlan(name: "Plan E", ester: .valerate, frequency: 10, dosage: 6.0, firstInjectionDate: fifthStoredDate),
            TreatmentPlan(name: "Plan F", ester: .enanthate, frequency: 21, dosage: 7.0, firstInjectionDate: sixthStoredDate)
        ]
        for plan in plans {
            try repo.add(item: plan)
        }
        #expect(repo.allItems.count == plans.count, "TreatmentPlanRepository should return all configured treatment plans after multiple adds")
        plans.forEach { plan in
            #expect(
                repo.allItems.contains(where: {
                    $0.name == plan.name &&
                    $0.ester == plan.ester &&
                    $0.frequency == plan.frequency &&
                    $0.dosage == plan.dosage &&
                    $0.firstInjectionDate == plan.firstInjectionDate
                }),
                "TreatmentPlanRepository should contain configured treatment plan name=\(plan.name), ester=\(plan.ester.rawValue), frequency=\(plan.frequency), dosage=\(plan.dosage), firstInjectionDate=\(plan.firstInjectionDate.timeIntervalSinceReferenceDate)"
            )
        }
    }

    @Test("Deletes one treatment plan")
    func testDeleteTreatmentPlan() async throws {
        let plan = getBurnerPlan()
        try repo.add(item: plan)
        try repo.delete(item: plan)
        #expect(repo.allItems.count == 0, "TreatmentPlanRepository should return no treatment plans after delete")
    }

    @Test("Deletes all treatment plans")
    func testDeleteAll() throws {
        let plan1 = getBurnerPlan()
        let plan2 = getBurnerPlan()
        try repo.add(item: plan1)
        try repo.add(item: plan2)
        #expect(repo.allItems.count == 2, "TreatmentPlanRepository should return all configured treatment plans before deleteAll")
        try repo.deleteAll()
        #expect(repo.allItems.count == 0, "TreatmentPlanRepository should return no treatment plans after deleteAll")
    }
}

extension TreatmentPlanRepositoryTests {
    func getBurnerPlan() -> TreatmentPlan {
        TreatmentPlan(name: "My Plan", ester: .enanthate, frequency: 7, dosage: 3.0, firstInjectionDate: .init())
    }
}
