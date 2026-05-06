import Testing
import Foundation
import Lottie
@testable import Spirit_Level

@Suite("Mood Cell View")
@MainActor
struct MoodCellViewModelTests {
    private let injectionDate = Date.now.start
    @Test("No injection")
    func noInjections() {
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: []))
        #expect(viewModel.getMood(at: Date()) == .unclear)
    }

    @Test("Before first injection")
    func dateBeforeInjection() throws {
        let injection = Injection(ester: .enanthate, dosage: 5.0, date: injectionDate)
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let date = try #require(Calendar.current.date(byAdding: .day, value: -1, to: injectionDate.start))
        #expect(viewModel.getMood(at: date) == .unclear)
    }

    @Test("One injection - rising, before risingMid")
    func happyMood() throws {
        let injection = Injection(ester: .enanthate, dosage: 5.0, date: injectionDate)
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let date = try #require(Calendar.current.date(byAdding: .day, value: 1, to: injectionDate.start))
        #expect(viewModel.getMood(at: date) == .happy)
    }

    @Test("One injection - rising, between risingMid and peak")
    func confidentMood() throws {
        let injection = Injection(ester: .enanthate, dosage: 5.0, date: injectionDate)
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let date = try #require(Calendar.current.date(byAdding: .day, value: 5, to: injectionDate.start))
        #expect(viewModel.getMood(at: date) == .confident)
    }

    @Test("One injection - falling, between peak and fallingMid")
    func poutingMood() throws {
        let injection = Injection(ester: .enanthate, dosage: 5.0, date: injectionDate)
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let date = try #require(Calendar.current.date(byAdding: .minute, value: 8 * 24 * 60 + 12 * 60, to: injectionDate.start))
        #expect(viewModel.getMood(at: date) == .pouting)
    }

    @Test("One injection - falling, between fallingMid and nextInjection")
    func sadNearNextInjection() throws {
        let injection = Injection(ester: .enanthate, dosage: 5.0, date: injectionDate)
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let date = try #require(Calendar.current.date(byAdding: .minute, value: 9 * 24 * 60 + 12 * 60, to: injectionDate.start))
        #expect(viewModel.getMood(at: date) == .sad)
    }

    @Test("One injection - past next injection date")
    func sadPastNextInjection() throws {
        let injection = Injection(ester: .enanthate, dosage: 5.0, date: injectionDate)
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let date = try #require(Calendar.current.date(byAdding: .day, value: 12, to: injectionDate.start))
        #expect(viewModel.getMood(at: date) == .sad)
    }

    @Test("Multiple injections - latest injection still reads as rising")
    func multipleInjectionsRisingMood() throws {
        let injections = [
            Injection(
                ester: .enanthate,
                dosage: 5.0,
                date: try #require(Calendar.current.date(byAdding: .day, value: -7, to: injectionDate))
            ),
            Injection(ester: .enanthate, dosage: 1.0, date: injectionDate)
        ]
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: injections))
        let date = try #require(Calendar.current.date(byAdding: .day, value: 1, to: injectionDate))

        #expect(viewModel.getMood(at: date) == .happy)
    }

    @Test("Multiple injections - falling trend in rising window is unsure")
    func unsureMoodWithMultipleInjections() throws {
        let injections = [
            Injection(
                ester: .enanthate,
                dosage: 5.0,
                date: try #require(Calendar.current.date(byAdding: .day, value: -7, to: injectionDate))
            ),
            Injection(ester: .enanthate, dosage: 1.0, date: injectionDate)
        ]
        let viewModel = MoodCellViewModel(dependencies: makeDependencies(injections: injections))
        let date = try #require(Calendar.current.date(byAdding: .day, value: 3, to: injectionDate))

        #expect(viewModel.getMood(at: date) == .unsure)
    }

    @Test("Treatment plan with default frequency matches ester default", arguments: Ester.allCases)
    func treatmentPlanWithDefaultFrequencyMatchesDefaultRhythm(ester: Ester) throws {
        let injection = Injection(ester: ester, dosage: 5.0, date: injectionDate)
        let treatmentPlan = TreatmentPlan(
            name: "\(ester.name) Plan",
            ester: ester,
            frequency: ester.defaultRhythm,
            dosage: 5.0,
            firstInjectionDate: try #require(Calendar.current.date(byAdding: .day, value: -1, to: injectionDate))
        )
        let date = try #require(
            Calendar.current.date(
                byAdding: .minute,
                value: ester.defaultRhythm * 24 * 60 + 60,
                to: injectionDate
            )
        )

        let defaultViewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let configuredViewModel = MoodCellViewModel(
            dependencies: makeDependencies(injections: [injection], treatmentPlans: [treatmentPlan])
        )

        #expect(defaultViewModel.getMood(at: date) == .sad)
        #expect(configuredViewModel.getMood(at: date) == .sad)
        #expect(defaultViewModel.getMood(at: date) == configuredViewModel.getMood(at: date))
    }

    @Test("Treatment plan with shorter frequency", arguments: Ester.allCases)
    func treatmentPlanWithShortFrequency(ester: Ester) throws {
        let shortenedFrequency = Int(floor(ester.configuration.tMax / 2 - 1))
        let injection = Injection(ester: ester, dosage: 5.0, date: injectionDate)
        let treatmentPlan = TreatmentPlan(
            name: "\(ester.name) Plan",
            ester: ester,
            frequency: shortenedFrequency,
            dosage: 5.0,
            firstInjectionDate: try #require(Calendar.current.date(byAdding: .day, value: -1, to: injectionDate))
        )

        let defaultViewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let configuredViewModel = MoodCellViewModel(
            dependencies: makeDependencies(injections: [injection], treatmentPlans: [treatmentPlan])
        )

        let tMaxDate = try #require(
            Calendar.current.date(
                byAdding: .minute,
                value: Int((ester.configuration.tMax * 24 * 60).rounded()),
                to: injectionDate.start
            )
        )
        #expect(configuredViewModel.getMood(at: tMaxDate) == defaultViewModel.getMood(at: tMaxDate))
        #expect(configuredViewModel.getMood(at: tMaxDate) == defaultViewModel.getMood(at: tMaxDate))
    }

    @Test("Treatment plan with longer frequency", arguments: Ester.allCases)
    func treatmentPlanWithLongerFrequency(ester: Ester) throws {
        let extendedFrequency = ester.defaultRhythm + 2
        let injection = Injection(ester: ester, dosage: 5.0, date: injectionDate)
        let treatmentPlan = TreatmentPlan(
            name: "\(ester.name) Plan",
            ester: ester,
            frequency: extendedFrequency,
            dosage: 5.0,
            firstInjectionDate: try #require(Calendar.current.date(byAdding: .day, value: -1, to: injectionDate))
        )
        let peak = ester.configuration.tMax
        let defaultFallingMid = peak + (Double(ester.defaultRhythm) - peak) / 2
        let extendedFallingMid = peak + (Double(extendedFrequency) - peak) / 2
        let midpoint = (defaultFallingMid + extendedFallingMid) / 2
        let date = try #require(
            Calendar.current.date(
                byAdding: .minute,
                value: Int((midpoint * 24 * 60).rounded()),
                to: injectionDate
            )
        )

        let defaultViewModel = MoodCellViewModel(dependencies: makeDependencies(injections: [injection]))
        let configuredViewModel = MoodCellViewModel(
            dependencies: makeDependencies(injections: [injection], treatmentPlans: [treatmentPlan])
        )

        #expect(defaultViewModel.getMood(at: date) == .sad)
        #expect(configuredViewModel.getMood(at: date) == .pouting)
    }
}

// MARK: - Lottie Resources

extension MoodCellViewModelTests {
    @Test("Mood Lottie Resources", arguments: Mood.allCases)
    func testMoodLottieResources(_ mood: Mood) throws {
        let viewModel = MoodCellViewModel(dependencies: AppDependenciesMock.none)
        let resourceName = LottieAnimation.named(viewModel.getLottieResourceName(for: mood))
        #expect(resourceName != nil)
    }
}

// MARK: - Helper

private extension MoodCellViewModelTests {
    func makeDependencies(
        injections: [Injection],
        treatmentPlans: [TreatmentPlan] = []
    ) -> AppDependenciesMock {
        AppDependenciesMock(
            appStateManager: .init(),
            appStartRepository: .new,
            injectionRepository: InjectionRepositoryMock(allItems: injections),
            labResultsRepository: .none,
            treatmentPlanRepository: TreatmentPlanManagerMock(allItems: treatmentPlans),
            hormoneLevelManager: .init()
        )
    }
}
