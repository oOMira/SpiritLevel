import Testing
import HealthDataLogging
import SpiritLevelShared
import SpiritLevelSharedTesting
import Foundation
@testable import Spirit_Level

@Suite("Achievement Manager", .tags(.treatmentPlans, .injections, .labResults))
@MainActor struct AchievementManagerTests {

    // MARK: - General Tests

    @Test("Fresh app start")
    func freshAppStart() {
        let date = Date()
        let dependencies = AppDependenciesMock(appStateManager: .init(),
                                               appStartRepository: .init(firstAppStart: .init()),
                                               injectionRepository: .none,
                                               labResultsRepository: .none,
                                               treatmentPlanRepository: .none,
                                               hormoneLevelManager: .init())
        let manager = MockAchievementManager(dependencies: dependencies)
        let isDoneArray = Achievement.allCases.map {
            manager.isAchievementDone($0, date: date)
        }
        let finishedCount = isDoneArray.count(where: { $0 })
        let unfinishedCount = isDoneArray.count(where: { !$0 })
        #expect(finishedCount == 1, "Only one achievement should be done on fresh start")
        #expect(unfinishedCount == Achievement.allCases.count - 1, "All but one achievement should be incomplete on fresh start")
    }

    @Test("All achievements completed")
    func allAchievementsCompleted() {
        let date = Date()
        let manager = MockAchievementManager(dependencies: .many)
        let isDoneArray = Achievement.allCases.map {
            manager.isAchievementDone($0, date: date)
        }
        let finishedCount = isDoneArray.count(where: { $0 })
        let unfinishedCount = isDoneArray.count(where: { !$0 })
        #expect(finishedCount == Achievement.allCases.count, "All achievements should be completed")
        #expect(unfinishedCount == 0, "No achievement should be incomplete when all are done")
    }

    @Test("No achievements completed")
    func noAchievementsCompleted() {
        let date = Date()
        let manager = MockAchievementManager(dependencies: .none)
        let isDoneArray = Achievement.allCases.map {
            manager.isAchievementDone($0, date: date)
        }
        let finishedCount = isDoneArray.count(where: { $0 })
        let unfinishedCount = isDoneArray.count(where: { !$0 })
        #expect(finishedCount == 0, "No achievement should be completed")
        #expect(unfinishedCount == Achievement.allCases.count, "All achievements should be incomplete when none are done")
    }

    // MARK: - Streak Achievements

    @Test("Streak achievement", arguments: StreakArgument.all)
    func streakAchievement(_ testCase: StreakArgument) throws {
        let now = Date()
        let notDoneManager = MockAchievementManager(dependencies: try makeStreakDependencies(onTimeCount: testCase.threshold - 1))
        let doneManager = MockAchievementManager(dependencies: try makeStreakDependencies(onTimeCount: testCase.threshold))
        let moreThanDoneManager = MockAchievementManager(dependencies: try makeStreakDependencies(onTimeCount: testCase.threshold + 1))

        #expect(!notDoneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should not be done below threshold")
        #expect(doneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should be done at threshold")
        #expect(moreThanDoneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should be done above threshold")
    }

    @Test("Streak achievement - injection not on time")
    func testStreakInjectionWrongTime() throws {
        let now = Date()
        let yesterday = try #require(Calendar.current.date(byAdding: .day, value: -1, to: now)).start

        let treatmentPlan = TreatmentPlan(name: "Test", ester: .enanthate, frequency: 7, dosage: 1.0, firstInjectionDate: yesterday)
        let injections: [Injection] = [
            .init(ester: .enanthate, dosage: 1.0, date: now)
        ]

        let dependencies = AppDependenciesMock(appStateManager: .init(),
                                               appStartRepository: .new,
                                               injectionRepository: .init(allItems: injections),
                                               labResultsRepository: .none,
                                               treatmentPlanRepository: .init(allItems: [treatmentPlan]),
                                               hormoneLevelManager: .init())

        let manager = MockAchievementManager(dependencies: dependencies)

        let isDone = manager.isAchievementDone(.sStreak, date: now)
        #expect(!isDone, "Injections streak should not count late injection")
    }

    @Test("Streak achievement - injection without plan")
    func testStreakInjectionWithoutPlan() {
        let now = Date()
        let injections: [Injection] = [.init(ester: .enanthate, dosage: 1.0, date: now)]
        let dependencies = AppDependenciesMock(appStateManager: .init(),
                                               appStartRepository: .new,
                                               injectionRepository: .init(allItems: injections),
                                               labResultsRepository: .none,
                                               treatmentPlanRepository: .none,
                                               hormoneLevelManager: .init())
        let manager = MockAchievementManager(dependencies: dependencies)

        let isDone = manager.isAchievementDone(.sStreak, date: now)
        #expect(!isDone, "Injections streak should not count without a plan")
    }

    // MARK: - Time Achievements

    @Test("Time achievement", arguments: TimeArgument.all)
    func timeAchievement(_ testCase: TimeArgument) throws {
        let now = Date()

        let thresholdDate = try #require(Calendar.current.date(byAdding: .month, value: testCase.monthsOffset, to: now))
        let notDoneDate = try #require(Calendar.current.date(byAdding: .month, value: 1, to: thresholdDate))
        let notYetDoneDate = try #require(Calendar.current.date(byAdding: .day, value: 1, to: thresholdDate))
        let justDoneDate = try #require(Calendar.current.date(byAdding: .day, value: -1, to: thresholdDate))
        let doneDate = try #require(Calendar.current.date(byAdding: .month, value: -1, to: thresholdDate))

        let notDoneManager = MockAchievementManager(dependencies: makeTimeDependencies(appStart: notDoneDate))
        let notYetDoneManager = MockAchievementManager(dependencies: makeTimeDependencies(appStart: notYetDoneDate))
        let thresholdManager = MockAchievementManager(dependencies: makeTimeDependencies(appStart: thresholdDate))
        let justDoneManager = MockAchievementManager(dependencies: makeTimeDependencies(appStart: justDoneDate))
        let doneManager = MockAchievementManager(dependencies: makeTimeDependencies(appStart: doneDate))

        #expect(!notDoneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should not be done before threshold")
        #expect(!notYetDoneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should not be done one day before threshold")
        #expect(thresholdManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should be done at threshold")
        #expect(justDoneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should be done one day after threshold")
        #expect(doneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should be done well after threshold")
    }

    // MARK: - Injection Count Achievements

    @Test("Injection achievement", arguments: InjectionArgument.all)
    func injectionCountAchievement(_ testCase: InjectionArgument) throws {
        let now = Date()

        let notDoneManager = MockAchievementManager(dependencies: makeInjectionDependencies(count: testCase.threshold - 1))
        let doneManager = MockAchievementManager(dependencies: makeInjectionDependencies(count: testCase.threshold))
        let moreThanDoneManager = MockAchievementManager(dependencies: try makeStreakDependencies(onTimeCount: testCase.threshold + 1))

        #expect(!notDoneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should not be done below threshold")
        #expect(doneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should be done at threshold")
        #expect(moreThanDoneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should be done above threshold")
    }

    // MARK: - Lab Result Achievements

    @Test("Lab result achievement", arguments: LabResultArgument.all)
    func labResultAchievement(_ testCase: LabResultArgument) throws {
        let now = Date()
        let notDoneManager = MockAchievementManager(dependencies: makeLabDependencies(count: testCase.threshold - 1))
        let doneManager = MockAchievementManager(dependencies: makeLabDependencies(count: testCase.threshold))
        let moreThanDoneManager = MockAchievementManager(dependencies: makeLabDependencies(count: testCase.threshold + 1))

        #expect(!notDoneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should not be done below threshold")
        #expect(doneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should be done at threshold")
        #expect(moreThanDoneManager.isAchievementDone(testCase.achievement, date: now), "\(testCase.achievement) should be done above threshold")
    }
}

// MARK: - Test Arguments

extension AchievementManagerTests {
    struct StreakArgument: CustomTestStringConvertible, Sendable {
        let achievement: Achievement
        let threshold: Int
        var testDescription: String { "\(achievement)" }

        static let all: [StreakArgument] = [
            .init(achievement: .sStreak, threshold: 5),
            .init(achievement: .mStreak, threshold: 10),
            .init(achievement: .lStreak, threshold: 25)
        ]
    }

    struct TimeArgument: CustomTestStringConvertible, Sendable {
        let achievement: Achievement
        let monthsOffset: Int
        var testDescription: String { "\(achievement)" }

        static let all: [TimeArgument] = [
            .init(achievement: .sTime, monthsOffset: 0),
            .init(achievement: .mTime, monthsOffset: -6),
            .init(achievement: .lTime, monthsOffset: -12),
            .init(achievement: .xlTime, monthsOffset: -24)
        ]
    }

    struct InjectionArgument: CustomTestStringConvertible, Sendable {
        let achievement: Achievement
        let threshold: Int
        var testDescription: String { "\(achievement)" }

        static let all: [InjectionArgument] = [
            .init(achievement: .firstInjection, threshold: 1),
            .init(achievement: .sInjection, threshold: 10),
            .init(achievement: .mInjection, threshold: 25),
            .init(achievement: .lInjection, threshold: 50)
        ]
    }

    struct LabResultArgument: CustomTestStringConvertible, Sendable {
        let achievement: Achievement
        let threshold: Int
        var testDescription: String { "\(achievement)" }

        static let all: [LabResultArgument] = [
            .init(achievement: .firstLab, threshold: 1),
            .init(achievement: .sLab, threshold: 5),
            .init(achievement: .mLab, threshold: 10),
            .init(achievement: .lLab, threshold: 15)
        ]
    }
}

// MARK: - Helper

extension AchievementManagerTests {
    private func makeStreakDependencies(onTimeCount: Int) throws -> AppDependenciesMock {
        let referenceDate = try #require(Calendar.current.date(byAdding: .year, value: -5, to: Date())).start
        let plan = TreatmentPlan(name: "Test", ester: .enanthate, frequency: 7, dosage: 1.0, firstInjectionDate: referenceDate)
        let injections = try (0..<onTimeCount).map { i in
            Injection(ester: .enanthate, dosage: 1.0, date: try #require(Calendar.current.date(byAdding: .day, value: i * 7, to: referenceDate)))
        }
        return .init(
            appStateManager: .init(),
            appStartRepository: .new,
            injectionRepository: .init(allItems: injections),
            labResultsRepository: .none,
            treatmentPlanRepository: .init(allItems: [plan]),
            hormoneLevelManager: .init()
        )
    }

    private func makeTimeDependencies(appStart: Date?) -> AppDependenciesMock {
        .init(
            appStateManager: .init(),
            appStartRepository: .init(firstAppStart: appStart),
            injectionRepository: .none,
            labResultsRepository: .none,
            treatmentPlanRepository: .none,
            hormoneLevelManager: .init()
        )
    }

    private func makeInjectionDependencies(count: Int) -> AppDependenciesMock {
        let injections = (0..<count).map { _ in
            Injection(ester: .enanthate, dosage: 1.0, date: .distantPast)
        }
        return .init(
            appStateManager: .init(),
            appStartRepository: .new,
            injectionRepository: .init(allItems: injections),
            labResultsRepository: .none,
            treatmentPlanRepository: .none,
            hormoneLevelManager: .init()
        )
    }

    private func makeLabDependencies(count: Int) -> AppDependenciesMock {
        let results = (0..<count).map { _ in
            LabResult(concentration: 250.0, date: .distantPast)
        }
        return .init(
            appStateManager: .init(),
            appStartRepository: .new,
            injectionRepository: .none,
            labResultsRepository: .init(allItems: results),
            treatmentPlanRepository: .none,
            hormoneLevelManager: .init()
        )
    }

}

// MARK: - MockAchievementManager

private final class MockAchievementManager: AchievementsManageable {
    let dependencies: AppDependenciesMock

    init(dependencies: AppDependenciesMock) {
        self.dependencies = dependencies
    }
}
