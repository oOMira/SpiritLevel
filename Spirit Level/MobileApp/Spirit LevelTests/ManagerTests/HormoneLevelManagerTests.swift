import Testing
import HealthDataLogging
import SpiritLevelShared
import Foundation
@testable import Spirit_Level

@Suite("Hormone Level Manager")
@MainActor
struct HormoneLevelManagerTests {
    let manager = HormoneLevelManager()
    let referenceDate = Date.now.start

    private func makeInjection(
        ester: Ester,
        dosage: Double,
        daysBeforeReference days: Double = 0
    ) -> Injection {
        Injection(
            ester: ester,
            dosage: dosage,
            date: referenceDate.addingTimeInterval(-days * 24 * 60 * 60)
        )
    }

    @Test("Level for no injections")
    func noInjections() {
        let level = manager.levelForInjections([], at: referenceDate)
        #expect(level == 0.0)
    }

    @Test("Level before injections")
    func beforeInjectionDate() {
        let ester = Ester.enanthate
        let injection = makeInjection(ester: ester, dosage: ester.defaultDose)
        let oneDayBefore = referenceDate.addingTimeInterval(-24 * 60 * 60)
        let level = manager.levelForInjections([injection], at: oneDayBefore)
        #expect(level == 0.0)
    }

    @Test("Level at exact injection time")
    func atExactInjectionTime() {
        let ester = Ester.enanthate
        let injection = makeInjection(ester: ester, dosage: ester.defaultDose)
        let level = manager.levelForInjections([injection], at: referenceDate)
        #expect(level == 0.0)
    }
    
    @Test("Level after injection", arguments: Ester.allCases)
    func positiveAfterInjection(ester: Ester) {
        let injection = makeInjection(ester: ester, dosage: 5.0)
        let shortlyAfter = dateAfterInjection(days: 0.5)
        let level = manager.levelForInjections([injection], at: shortlyAfter)
        #expect(level > 0.0)
    }

    @Test("Level at tMax", arguments: Ester.allCases)
    func peakAtTMax(ester: Ester) {
        let config = ester.configuration
        let injection = makeInjection(ester: ester, dosage: config.dose)
        
        let maxDate = dateAfterInjection(days: config.tMax)
        let level = manager.levelForInjections([injection], at: maxDate)
        
        let margin = config.cMax * 0.05
        let lowerBound = config.cMax - margin
        let upperBound = config.cMax + margin

        #expect((lowerBound...upperBound).contains(level),
                "tMax level should be roughly cMax for \(ester.name)")
    }

    @Test("Level long time after injection", arguments: Ester.allCases)
    func levelApproachesZero(ester: Ester) {
        let config = ester.configuration
        let injection = makeInjection(ester: ester, dosage: config.dose)
        let farFuture = dateAfterInjection(days: config.tHalf * 10)
        let level = manager.levelForInjections([injection], at: farFuture)
        #expect(level < 1.0,
                "Level should approach zero after 10 half-lives for \(ester.name)")
    }

    @Test("Level scales linearly with dosage", arguments: Ester.allCases)
    func dosageScaling(ester: Ester) {
        let config = ester.configuration
        let singleDose = makeInjection(ester: ester, dosage: config.dose)
        let doubleDose = makeInjection(ester: ester, dosage: config.dose * 2)
        let at = dateAfterInjection(days: 4.0)

        let singleLevel = manager.levelForInjections([singleDose], at: at)
        let doubleLevel = manager.levelForInjections([doubleDose], at: at)

        #expect(abs(doubleLevel - 2.0 * singleLevel) < singleLevel * 0.05)
    }

    @Test("Test 100 injections")
    func hundredInjections() {
        let ester = Ester.enanthate
        let injections = (0..<100).map { i in
            makeInjection(ester: ester,
                          dosage: ester.configuration.dose,
                          daysBeforeReference: Double(i) * -3.0)
        }
        let at = dateAfterInjection(days: 300.0)
        let level = manager.levelForInjections(injections, at: at)
        #expect(level > 0.0)
    }

    @Test("Mixed ester injections combine correctly")
    func mixedEsters() {
        let enanthateConfig = Ester.enanthate.configuration
        let valerateConfig = Ester.valerate.configuration
        let enanthateInjection = makeInjection(ester: .enanthate, dosage: enanthateConfig.dose)
        let valerateInjection = makeInjection(ester: .valerate, dosage: valerateConfig.dose)
        let at = dateAfterInjection(days: 3.0)

        let combined = manager.levelForInjections(
            [enanthateInjection, valerateInjection], at: at
        )
        let enanthateOnly = manager.levelForInjections([enanthateInjection], at: at)
        let valerateOnly = manager.levelForInjections([valerateInjection], at: at)

        #expect(abs(combined - (enanthateOnly + valerateOnly)) < 0.001)
    }

    @Test("Level rising before peak", arguments: Ester.allCases)
    func risingBeforePeak(ester: Ester) {
        let config = ester.configuration
        let injection = makeInjection(ester: ester, dosage: config.dose)
        let beforePeak = dateAfterInjection(days: 1)
        let isFalling = manager.isLevelFallingForInjections([injection], at: beforePeak)
        #expect(isFalling == false)
    }

    @Test("Level falling after peak", arguments: Ester.allCases)
    func fallingAfterPeak(ester: Ester) {
        let config = ester.configuration
        let injection = makeInjection(ester: ester, dosage: config.dose)
        let afterPeak = dateAfterInjection(days: config.tMax + 1)
        let isFalling = manager.isLevelFallingForInjections([injection], at: afterPeak)
        #expect(isFalling)
    }
}

private extension HormoneLevelManagerTests {
    func dateAfterInjection(days: Double) -> Date {
        referenceDate.addingTimeInterval(days * 24 * 60 * 60)
    }
}
