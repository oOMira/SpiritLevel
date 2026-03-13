import Testing
import Foundation
@testable import Spirit_Level

@MainActor
struct AchievementManagerTests {

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
        #expect(finishedCount == 1)
        #expect(unfinishedCount == Achievement.allCases.count - 1)
    }

    @Test("All achievements completed")
    func allAchievementsCompleted() {
        let date = Date()
        let manager = MockAchievementManager(dependencies: .tone)
        let isDoneArray = Achievement.allCases.map {
            manager.isAchievementDone($0, date: date)
        }
        let finishedCount = isDoneArray.count(where: { $0 })
        let unfinishedCount = isDoneArray.count(where: { !$0 })
        #expect(finishedCount == Achievement.allCases.count)
        #expect(unfinishedCount == 0)
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
        #expect(finishedCount == 0)
        #expect(unfinishedCount == Achievement.allCases.count)
    }

    // MARK: - Streak Achievements

    // TODO: Update streak to count only once per date
    @Test("Streak achievement", arguments: [
        (Achievement.sStreak, 5),
        (.mStreak, 10),
        (.lStreak, 25)
    ])
    func streakAchievement(_ testCase: (Achievement, Int)) throws {
        let (achievement, threshold) = testCase
        let now = Date()
        let notDoneManager = MockAchievementManager(dependencies: try makeStreakDependencies(onTimeCount: threshold - 1))
        let doneManager = MockAchievementManager(dependencies: try makeStreakDependencies(onTimeCount: threshold))
        let moreThanDoneManager = MockAchievementManager(dependencies: try makeStreakDependencies(onTimeCount: threshold + 1))
        
        #expect(!notDoneManager.isAchievementDone(achievement, date: now))
        #expect(doneManager.isAchievementDone(achievement, date: now))
        #expect(moreThanDoneManager.isAchievementDone(achievement, date: now))
    }
    
    @Test("Streak achievment - injection not on time") func testStreakInjectionWrongTime() throws {
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
        #expect(!isDone)
    }
    
    @Test("Streak achievment - injection without plan") func testStreakInjectionWithoutPlan() {
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
        #expect(!isDone)
    }

    // MARK: - Time Achievements

    @Test("Time achievement", arguments: [
        (Achievement.sTime, 0),
        (.mTime, -6),
        (.lTime, -12),
        (.xlTime, -24)
    ])
    func timeAchievement(_ testCase: (Achievement, Int)) throws {
        let (achievement, threshold) = testCase
        let now = Date()
        
        let thresholdDate = try #require(Calendar.current.date(byAdding: .month, value: threshold, to: now))
        let notDoneDate = try #require(Calendar.current.date(byAdding: .month, value: 1, to: thresholdDate))
        let notYetDoneDate = try #require(Calendar.current.date(byAdding: .day, value: 1, to: thresholdDate))
        let justDoneDate = try #require(Calendar.current.date(byAdding: .day, value: -1, to: thresholdDate))
        let doneDate = try #require(Calendar.current.date(byAdding: .month, value: -1, to: thresholdDate))
        
        
        let notDoneManager = MockAchievementManager(dependencies: makeTimeDependencies(appStart: notDoneDate))
        let notYetDoneManager = MockAchievementManager(dependencies: makeTimeDependencies(appStart: notYetDoneDate))
        let thresholdManager = MockAchievementManager(dependencies: makeTimeDependencies(appStart: thresholdDate))
        let justDoneManager = MockAchievementManager(dependencies: makeTimeDependencies(appStart: justDoneDate))
        let doneManager = MockAchievementManager(dependencies: makeTimeDependencies(appStart: doneDate))
        
        #expect(!notDoneManager.isAchievementDone(achievement, date: now))
        #expect(!notYetDoneManager.isAchievementDone(achievement, date: now))
        #expect(thresholdManager.isAchievementDone(achievement, date: now))
        #expect(justDoneManager.isAchievementDone(achievement, date: now))
        #expect(doneManager.isAchievementDone(achievement, date: now))
    }

    // MARK: - Injection Count Achievements

    @Test("Injection achievement", arguments: [
        (Achievement.firstInjection, 1),
        (.sInjection, 10),
        (.mInjection, 25),
        (.lInjection, 50)
    ])
    func injectionCountAchievement(_ testCase: (Achievement, Int)) throws {
        let (achievement, threshold) = testCase
        let now = Date()

        let notDoneManager = MockAchievementManager(dependencies: makeInjectionDependencies(count: threshold - 1))
        let doneManager = MockAchievementManager(dependencies: makeInjectionDependencies(count: threshold))
        let moreThanDoneManager = MockAchievementManager(dependencies: try makeStreakDependencies(onTimeCount: threshold + 1))
        
        #expect(!notDoneManager.isAchievementDone(achievement, date: now))
        #expect(doneManager.isAchievementDone(achievement, date: now))
        #expect(moreThanDoneManager.isAchievementDone(achievement, date: now))
    }

    // MARK: - Lab Result Achievements

    @Test("Lab result achievement", arguments: [
        (Achievement.firstLab, 1),
        (.sLab, 5),
        (.mLab, 10),
        (.lLab, 15)
    ])
    func labResultAchievement(_ testCase: (Achievement, Int)) throws {
        let (achievement, threshold) = testCase
        let now = Date()
        let notDoneManager = MockAchievementManager(dependencies: makeLabDependencies(count: threshold - 1))
        let doneManager = MockAchievementManager(dependencies: makeLabDependencies(count: threshold))
        let moreThanDoneManager = MockAchievementManager(dependencies: makeLabDependencies(count: threshold + 1))
        
        #expect(!notDoneManager.isAchievementDone(achievement, date: now))
        #expect(doneManager.isAchievementDone(achievement, date: now))
        #expect(moreThanDoneManager.isAchievementDone(achievement, date: now))
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
        let injections = (0..<count).map { i in
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
