import Testing
import Foundation
@testable import Spirit_Level

@Suite("Injection Date Manager")
@MainActor
struct InjectionDateManagerTests {
    let date = Date.now.start
    
    @Test("No treatment")
    func noTreatmentPlan() throws {
        let manager = MockInjectionDateManager(dependencies: .none)
        #expect(manager.getNextInjectionDate(until: .distantFuture) == nil)
    }
    
    @Test("Today plan with no injections")
    func todayPlanNoInjections() throws {
        let plan = TreatmentPlan(name: "Today Plan",
                                 ester: .enanthate,
                                 frequency: 7,
                                 dosage: 7,
                                 firstInjectionDate: date)
        let manager = makeManager(injections: [], plans: [plan])
        let nextInjectionDate = manager.getNextInjectionDate(until: date)
        
        #expect(nextInjectionDate == date.start)
    }
    
    @Test("Today plan with no injections, later on same day")
    func testInjectionLaterSameDay() throws {
        let plan = TreatmentPlan(name: "Today Plan",
                                 ester: .enanthate,
                                 frequency: 7,
                                 dosage: 7,
                                 firstInjectionDate: date)
        let manager = makeManager(injections: [], plans: [plan])
        
        let laterSameDayDate = try #require(Calendar.current.date(byAdding: .hour,
                                                                  value: 2,
                                                                  to: date))
        
        let nextInjectionDate = manager.getNextInjectionDate(until: date)
        let nextInjectionDateLater = manager.getNextInjectionDate(until: laterSameDayDate)
        
        #expect(nextInjectionDate == date.start)
        #expect(nextInjectionDateLater == date.start)
    }

    @Test("Future plan with no injections")
    func futurePlanNoInjections() throws{
        let futurePlanDate = try #require(Calendar.current.date(byAdding: .day,
                                                                value: 7,
                                                                to: date))
        let plan = TreatmentPlan(name: "Future Plan",
                                 ester: .enanthate,
                                 frequency: 7,
                                 dosage: 5,
                                 firstInjectionDate: futurePlanDate)
        let manager = makeManager(injections: [], plans: [plan])
        
        let nextInjectionDate = manager.getNextInjectionDate(until: date)
        
        #expect(nextInjectionDate == futurePlanDate.start)
    }

    @Test("Old treatment plan with no injections")
    func oldTreatmentPlanNoInjections() throws {
        let oldPlanDate = try #require(Calendar.current.date(byAdding: .day,
                                                             value: -21,
                                                             to: date))
        
        
        let plan = TreatmentPlan(name: "Old Plan",
                                 ester: .enanthate,
                                 frequency: 7,
                                 dosage: 5,
                                 firstInjectionDate: oldPlanDate)
        
        let manager = makeManager(injections: [], plans: [plan])

        let nextInjectionDate = manager.getNextInjectionDate(until: date)
        
        let expectedDate = try #require(Calendar.current.date(byAdding: .day,
                                                              value: -1,
                                                              to: date))

        #expect(nextInjectionDate == expectedDate.start)
    }

//    @Test("On-time last injection returns the next scheduled date")
//    func onTimeLastInjectionReturnsNextScheduledDate() throws {
//        let firstInjectionDate = try #require(date(year: 2024, month: 12, day: 18))
//        let expectedNextDate = try #require(date(year: 2025, month: 1, day: 8))
//        let plan = makeTreatmentPlan(firstInjectionDate: firstInjectionDate, frequency: 7)
//        let injections = [
//            makeInjection(date: firstInjectionDate),
//            makeInjection(date: try #require(date(year: 2024, month: 12, day: 25))),
//            makeInjection(date: try #require(date(year: 2025, month: 1, day: 1)))
//        ]
//        let manager = makeManager(
//            injections: injections,
//            plans: [plan]
//        )
//
//        let nextInjectionDate = manager.getNextInjectionDate(until: try referenceDate())
//
//        #expect(nextInjectionDate == expectedNextDate.start)
//    }
//
//    @Test("Missed scheduled injection returns the overdue planned date")
//    func missedScheduledInjectionReturnsOverduePlannedDate() throws {
//        let firstInjectionDate = try #require(date(year: 2024, month: 12, day: 18))
//        let overdueDate = try #require(date(year: 2025, month: 1, day: 1))
//        let plan = makeTreatmentPlan(firstInjectionDate: firstInjectionDate, frequency: 7)
//        let injections = [
//            makeInjection(date: firstInjectionDate),
//            makeInjection(date: try #require(date(year: 2024, month: 12, day: 25)))
//        ]
//        let manager = makeManager(
//            injections: injections,
//            plans: [plan]
//        )
//
//        let nextInjectionDate = manager.getNextInjectionDate(until: try referenceDate())
//
//        #expect(nextInjectionDate == overdueDate.start)
//    }
//
//    @Test("Planned injections list includes all occurrences up to the requested date")
//    func plannedInjectionsListIncludesAllOccurrencesUpToRequestedDate() throws {
//        let firstInjectionDate = try #require(date(year: 2024, month: 12, day: 18))
//        let plan = makeTreatmentPlan(firstInjectionDate: firstInjectionDate, frequency: 7)
//        let manager = makeManager(
//            injections: [],
//            plans: [plan]
//        )
//
//        let plannedDates = manager.getPlannedInjectionsList(until: try referenceDate()).map(\.date)
//
//        #expect(plannedDates == [
//            try #require(date(year: 2024, month: 12, day: 18)).start,
//            try #require(date(year: 2024, month: 12, day: 25)).start,
//            try #require(date(year: 2025, month: 1, day: 1)).start,
//            try #require(date(year: 2025, month: 1, day: 8)).start
//        ])
//    }
//
//    @Test("Planned injections switch to the next treatment plan when it starts")
//    func plannedInjectionsSwitchToNextTreatmentPlanWhenItStarts() throws {
//        let firstPlanFirstDate = try #require(date(year: 2024, month: 12, day: 15))
//        let firstPlanSecondDate = try #require(date(year: 2024, month: 12, day: 22))
//        let firstPlanThirdDate = try #require(date(year: 2024, month: 12, day: 29))
//        let secondPlanFirstDate = try #require(date(year: 2025, month: 1, day: 1))
//        let secondPlanSecondDate = try #require(date(year: 2025, month: 1, day: 6))
//        let firstPlan = makeTreatmentPlan(
//            name: "Plan A",
//            firstInjectionDate: firstPlanFirstDate,
//            frequency: 7
//        )
//        let secondPlan = makeTreatmentPlan(
//            name: "Plan B",
//            firstInjectionDate: secondPlanFirstDate,
//            frequency: 5
//        )
//        let manager = makeManager(
//            injections: [],
//            plans: [firstPlan, secondPlan]
//        )
//
//        let plannedInjections = manager.getPlannedInjectionsList(until: try referenceDate())
//
//        #expect(plannedInjections.count == 5)
//        #expect(plannedInjections[0].date == firstPlanFirstDate.start)
//        #expect(plannedInjections[0].plan.name == "Plan A")
//        #expect(plannedInjections[1].date == firstPlanSecondDate.start)
//        #expect(plannedInjections[1].plan.name == "Plan A")
//        #expect(plannedInjections[2].date == firstPlanThirdDate.start)
//        #expect(plannedInjections[2].plan.name == "Plan A")
//        #expect(plannedInjections[3].date == secondPlanFirstDate.start)
//        #expect(plannedInjections[3].plan.name == "Plan B")
//        #expect(plannedInjections[4].date == secondPlanSecondDate.start)
//        #expect(plannedInjections[4].plan.name == "Plan B")
//    }
}

// MARK: - Helpers

extension InjectionDateManagerTests {
    private func makeManager(
        injections: [Injection],
        plans: [TreatmentPlan]
    ) -> MockInjectionDateManager {
        MockInjectionDateManager(
            dependencies: .init(
                appStateManager: .init(),
                appStartRepository: .new,
                injectionRepository: .init(allItems: injections),
                labResultsRepository: .none,
                treatmentPlanRepository: .init(allItems: plans),
                hormoneLevelManager: .init()
            )
        )
    }
}

private final class MockInjectionDateManager: InjectionDateManageable {
    let dependencies: AppDependenciesMock

    init(dependencies: AppDependenciesMock) {
        self.dependencies = dependencies
    }
}
