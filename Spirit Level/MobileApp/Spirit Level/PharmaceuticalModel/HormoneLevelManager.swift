import Foundation
import HealthDataLogging

protocol HormoneLevelManageable: AnyObject {
    func levelForInjections(_ injections: [Injection], at date: Date) -> Double
    func isLevelFallingForInjections(_ injections: [Injection], at date: Date) -> Bool
}

protocol HasHormoneLevelManager: AnyObject, Observable {
    associatedtype HormoneLevelMgr: HormoneLevelManageable
    var hormoneLevelManager: HormoneLevelMgr { get set }
}

class HormoneLevelManager: HormoneLevelManageable {
    private let levelFunctions: [Ester: OneComponentBateman]

    init() {
        self.levelFunctions = Ester.allCases.reduce(into: [Ester: OneComponentBateman]()) { dict, ester in
            let configuration = ester.configuration
            let bateman = OneComponentBateman(
                halfLife: configuration.tHalf,
                peakTime: configuration.tMax,
                peakConcentration: configuration.cMax
            )
            dict[ester] = bateman
        }
    }

    func levelForInjections(_ injections: [Injection], at date: Date) -> Double {
        injections.reduce(into: 0.0) { level, injection in
            guard let levelFunction = levelFunctions[injection.ester] else { return }
            let timeInterval = date.timeIntervalSince(injection.date) / (24 * 60  * 60)
            let scale = injection.dosage / 5.0
            let timeNormalizedConcentration = levelFunction.getConcentrationAtTime(timeInterval) ?? 0.0
            let scaledConcentration = timeNormalizedConcentration * scale
            level += scaledConcentration
        }
    }

    func isLevelFallingForInjections(_ injections: [Injection], at date: Date) -> Bool {
        let currentLevel = levelForInjections(injections, at: date)
        let pastLevel = levelForInjections(injections, at: date.addingTimeInterval(-60 * 60)) // Check 1 hour earlier
        return pastLevel > currentLevel
    }
}
