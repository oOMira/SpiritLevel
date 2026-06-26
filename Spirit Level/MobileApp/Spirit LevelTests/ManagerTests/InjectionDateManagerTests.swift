import Testing
import HealthDataLogging
import SpiritLevelShared
import SpiritLevelSharedTesting
import Foundation
@testable import Spirit_Level

@Suite("Injection Date Manager", .tags(.treatmentPlans, .injections))
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
                                                             value: -15,
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
    
    @Test("old plan with one injection")
    func oldPlanWithOneInjection() throws {
        let oldPlanDate = try #require(Calendar.current.date(byAdding: .day,
                                                             value: -15,
                                                             to: date))
        
        let plan = TreatmentPlan(name: "Plan",
                                 ester: .enanthate,
                                 frequency: 5,
                                 dosage: 5,
                                 firstInjectionDate: oldPlanDate)
        
        let firstInjectionDate = try #require(Calendar.current.date(byAdding: .day,
                                                                    value: -15,
                                                                    to: date))
        
        let injections: [Injection] = [
            .init(ester: .enanthate, dosage: 5.0, date: firstInjectionDate)
        ]
        
        let manager = makeManager(injections: injections, plans: [plan])
        let nextInjectionDate = manager.getNextInjectionDate(until: date)
        
        #expect(nextInjectionDate == date.start)
    }
    
    @Test("old plan with one injection - today")
    func oldPlanWithOneInjectionToday() throws {
        let oldPlanDate = try #require(Calendar.current.date(byAdding: .day,
                                                             value: -15,
                                                             to: date))
        
        let plan = TreatmentPlan(name: "Plan",
                                 ester: .enanthate,
                                 frequency: 5,
                                 dosage: 5,
                                 firstInjectionDate: oldPlanDate)
        
        
        let injections: [Injection] = [
            .init(ester: .enanthate, dosage: 5.0, date: date.start)
        ]
        
        let manager = makeManager(injections: injections, plans: [plan])
        let nextInjectionDate = manager.getNextInjectionDate(until: date)
        
        let plannedInjectionDate = try #require(Calendar.current.date(byAdding: .day,
                                                                      value: 5,
                                                                      to: date))
        
        #expect(nextInjectionDate == plannedInjectionDate)
    }
    
    @Test("old plan with many injections")
    func oldPlanWithManyInjections() throws {
        let oldPlanDate = try #require(Calendar.current.date(byAdding: .day,
                                                             value: -15,
                                                             to: date))
        
        let plan = TreatmentPlan(name: "Plan",
                                 ester: .enanthate,
                                 frequency: 5,
                                 dosage: 5,
                                 firstInjectionDate: oldPlanDate)
        
        let firstInjectionDate = try #require(Calendar.current.date(byAdding: .day,
                                                                    value: -15,
                                                                    to: date))
        let secondInjectionDate = try #require(Calendar.current.date(byAdding: .day,
                                                                     value: -10,
                                                                     to: date))
        let thirdInjectionDate = try #require(Calendar.current.date(byAdding: .day,
                                                                    value: -5,
                                                                    to: date))
        
        let injections: [Injection] = [
            .init(ester: .enanthate, dosage: 5.0, date: firstInjectionDate),
            .init(ester: .enanthate, dosage: 5.0, date: secondInjectionDate),
            .init(ester: .enanthate, dosage: 5.0, date: thirdInjectionDate)
        ]
        
        let manager = makeManager(injections: injections, plans: [plan])
        let nextInjectionDate = manager.getNextInjectionDate(until: date)
        
        #expect(nextInjectionDate == date.start)
    }
    
    @Test("future plan with one injection")
    func futurePlanWithOneInjection() throws {
        let futurePlanDate = try #require(Calendar.current.date(byAdding: .day,
                                                                value: 5,
                                                                to: date))
        
        let plan = TreatmentPlan(name: "Plan",
                                 ester: .enanthate,
                                 frequency: 5,
                                 dosage: 5,
                                 firstInjectionDate: futurePlanDate)
        
        let injections: [Injection] = [
            .init(ester: .enanthate, dosage: 5.0, date: futurePlanDate),
        ]
        
        let manager = makeManager(injections: injections, plans: [plan])
        let nextInjectionDate = manager.getNextInjectionDate(until: date)
        
        let expectedInjectionDate = try #require(Calendar.current.date(byAdding: .day,
                                                                       value: 10,
                                                                       to: date))
        
        #expect(nextInjectionDate == expectedInjectionDate)
    }
    
    @Test("Planned injections - no treatment plan")
    func plannedInjectionsForNoTreatmentPlan() throws {
        let manager = makeManager(injections: [], plans: [])
        let plannedInjections = manager.getPlannedInjectionsList(until: date)
        #expect(plannedInjections.isEmpty)
    }
    
    @Test("Planned injections - one treatment plan")
    func plannedInjectionsForOneTreatmentPlan() throws {
        let startDate = try #require(Calendar.current.date(byAdding: .day,
                                                           value: -50,
                                                           to: date))
        let plan = TreatmentPlan(name: "Plan",
                                 ester: .enanthate,
                                 frequency: 5,
                                 dosage: 5,
                                 firstInjectionDate: startDate)
        
        let manager = makeManager(injections: [], plans: [plan])
        let plannedInjections = manager.getPlannedInjectionsList(until: date)
        
        for index in 0...10 {
            #expect(plannedInjections[index].plan.name == "Plan")
            let injectionDate = try #require(Calendar.current.date(byAdding: .day,
                                                                   value: -50 + 5*index,
                                                                   to: date))
            #expect(plannedInjections[index].date.start == injectionDate.start)
        }
        
        #expect(plannedInjections.count == 11)
    }
    
    @Test("Planned injections - multiple treatment plan")
    func plannedInjectionsForMultipleTreatmentPlan() throws {
        let firstStartDate = try #require(Calendar.current.date(byAdding: .day,
                                                                value: -100,
                                                                to: date))
        let secondStartDate = try #require(Calendar.current.date(byAdding: .day,
                                                                 value: -50,
                                                                 to: date))
        let firstPlan = TreatmentPlan(name: "Plan 1",
                                      ester: .enanthate,
                                      frequency: 5,
                                      dosage: 5,
                                      firstInjectionDate: firstStartDate)
        let secondPlan = TreatmentPlan(name: "Plan 2",
                                       ester: .enanthate,
                                       frequency: 10,
                                       dosage: 5,
                                       firstInjectionDate: secondStartDate)
        
        let manager = makeManager(injections: [], plans: [firstPlan, secondPlan])
        let plannedInjections = manager.getPlannedInjectionsList(until: date)
        
        #expect(plannedInjections.count == 17)
        
        // test first plan
        for index in 0...10 {
            #expect(plannedInjections[index].plan.name == "Plan 1")
            let injectionDate = try #require(Calendar.current.date(byAdding: .day,
                                                                   value: -100 + 5*index,
                                                                   to: date))
            #expect(plannedInjections[index].date.start == injectionDate.start)
        }
        
        // test second plan
        for index in 0...5 {
            let planIndex = index + 11
            #expect(plannedInjections[planIndex].plan.name == "Plan 2")
            let injectionDate = try #require(Calendar.current.date(byAdding: .day,
                                                                   value: -50 + 10*index,
                                                                   to: date))
            #expect(plannedInjections[planIndex].date.start == injectionDate.start)
        }
    }
    
    @Test("Planned injections same day cutoff", arguments: DayOffset.allCases)
    func plannedInjectionsForCutoffOnTodaysPlan(offset: DayOffset) throws {
        let cutoffDate = try #require(Calendar.current.date(byAdding: .day,
                                                            value: offset.days,
                                                            to: date))
        let plan = TreatmentPlan(name: "Plan",
                                 ester: .enanthate,
                                 frequency: 5,
                                 dosage: 5,
                                 firstInjectionDate: cutoffDate)
        
        let manager = makeManager(injections: [], plans: [plan])
        let plannedInjections = manager.getPlannedInjectionsList(until: cutoffDate)
        
        #expect(plannedInjections.count == 1)
        
        let firstPlannedInjection = try #require(plannedInjections.first)
        #expect(firstPlannedInjection.date.start == cutoffDate.start)
        #expect(firstPlannedInjection.plan.name == "Plan")
        #expect(firstPlannedInjection.plan.frequency == 5)
        #expect(firstPlannedInjection.plan.dosage == 5)
    }
    
    @Test("Planned injections earlier cutoff", arguments: DayOffset.allCases)
    func plannedInjectionsEarlierCutoff(offset: DayOffset) throws {
        let planDate = try #require(Calendar.current.date(byAdding: .day,
                                                          value: offset.days,
                                                          to: date))
        let cutoffDate = try #require(Calendar.current.date(byAdding: .day,
                                                            value: offset.days - 1,
                                                            to: date))
        let plan = TreatmentPlan(name: "Plan",
                                 ester: .enanthate,
                                 frequency: 5,
                                 dosage: 5,
                                 firstInjectionDate: planDate)
        
        let manager = makeManager(injections: [], plans: [plan])
        let plannedInjections = manager.getPlannedInjectionsList(until: cutoffDate)
        
        #expect(plannedInjections.isEmpty)
    }
    
    @Test("Planned injections later cutoff", arguments: DayOffset.allCases)
    func plannedInjectionsLaterCutoff(offset: DayOffset) throws {
        let planDate = try #require(Calendar.current.date(byAdding: .day,
                                                            value: offset.days,
                                                            to: date))
        let cutoffDate = try #require(Calendar.current.date(byAdding: .day,
                                                            value: offset.days + 1,
                                                            to: date))
        let plan = TreatmentPlan(name: "Plan",
                                 ester: .enanthate,
                                 frequency: 5,
                                 dosage: 5,
                                 firstInjectionDate: planDate)

        let manager = makeManager(injections: [], plans: [plan])
        let plannedInjections = manager.getPlannedInjectionsList(until: cutoffDate)

        #expect(plannedInjections.count == 1)
        
        let firstPlannedInjection = try #require(plannedInjections.first)
        #expect(firstPlannedInjection.date.start == planDate.start)
        #expect(firstPlannedInjection.plan.name == "Plan")
        #expect(firstPlannedInjection.plan.frequency == 5)
        #expect(firstPlannedInjection.plan.dosage == 5)
    }
}


// MARK: - Helpers

extension InjectionDateManagerTests {
    enum DayOffset: Int, CaseIterable {
        case distantPast = -100
        case past = -10
        case yesterday = -1
        case today = 0
        case tomorrow = 1
        case future = 10
        case distantFuture = 100
        
        var days: Int { rawValue }
    }
}

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
                treatmentPlanConfigurationRepository: .none,
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
