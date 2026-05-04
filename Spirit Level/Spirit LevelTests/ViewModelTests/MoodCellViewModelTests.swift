import Testing
import Foundation
import Lottie
@testable import Spirit_Level

@Suite("Mood Cell View")
@MainActor
struct MoodCellViewModelTests {
    @Test("Mood Lottie Resources", arguments: Mood.allCases)
    func testMoodLottieResources(_ mood: Mood) throws {
        let viewModel = MoodCellViewModel(dependencies: AppDependenciesMock.none)
        let resourceName = LottieAnimation.named(viewModel.getLottieResourceName(for: mood))
        #expect(resourceName != nil)
    }
}

extension MoodCellViewModelTests {
    private static let injectionDate = Date.now.start

    @Test("No injection")
    func noInjections() {
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: []))
        #expect(viewModel.getMood(at: Date()) == .unclear)
    }

    @Test("Before first injection")
    func dateBeforeInjection() {
        let injection = Injection(ester: .enanthate, dosage: 5.0, date: Self.injectionDate)
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let date = Self.injectionDate.start.addingTimeInterval(-1 * 24 * 60 * 60)
        #expect(viewModel.getMood(at: date) == .unclear)
    }

    @Test("One injection - rising, before risingMid")
    func happyMood() {
        let injection = Injection(ester: .enanthate, dosage: 5.0, date: Self.injectionDate)
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let date = Self.injectionDate.start.addingTimeInterval(1 * 24 * 60 * 60)
        #expect(viewModel.getMood(at: date) == .happy)
    }

    @Test("One injection - rising, between risingMid and peak")
    func confidentMood() {
        let injection = Injection(ester: .enanthate, dosage: 5.0, date: Self.injectionDate)
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let date = Self.injectionDate.start.addingTimeInterval(5 * 24 * 60 * 60)
        #expect(viewModel.getMood(at: date) == .confident)
    }

    @Test("One injection - falling, between peak and fallingMid")
    func poutingMood() {
        let injection = Injection(ester: .enanthate, dosage: 5.0, date: Self.injectionDate)
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let date = Self.injectionDate.start.addingTimeInterval(8.5 * 24 * 60 * 60)
        #expect(viewModel.getMood(at: date) == .pouting)
    }

    @Test("One injection - falling, between fallingMid and nextInjection")
    func sadNearNextInjection() {
        let injection = Injection(ester: .enanthate, dosage: 5.0, date: Self.injectionDate)
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let date = Self.injectionDate.start.addingTimeInterval(9.5 * 24 * 60 * 60)
        #expect(viewModel.getMood(at: date) == .sad)
    }

    @Test("One injection - past next injection date")
    func sadPastNextInjection() {
        let injection = Injection(ester: .enanthate, dosage: 5.0, date: Self.injectionDate)
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let date = Self.injectionDate.start.addingTimeInterval(12 * 24 * 60 * 60)
        #expect(viewModel.getMood(at: date) == .sad)
    }
}

// MARK: - Helper

private extension MoodCellViewModelTests {
    func makeDependencies(injections: [Injection]) -> AppDependenciesMock {
        AppDependenciesMock(
            appStateManager: .init(),
            appStartRepository: .new,
            injectionRepository: InjectionRepositoryMock(allItems: injections),
            labResultsRepository: .none,
            treatmentPlanRepository: .none,
            hormoneLevelManager: .init()
        )
    }
}
