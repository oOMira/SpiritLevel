import Foundation

// TODO: - Find better solution!!!!

protocol HormoneLevelManageable: AnyObject {
    func levelForInjections(_ injections: [Injection], at date: Date) -> Double
    func isLevelFallingForInjections(_ injections: [Injection], at date: Date) -> Bool
}

protocol HasHormoneLevelManager: AnyObject, Observable {
    associatedtype HormoneLevelManagerType: HormoneLevelManageable
    var hormoneLevelManager: HormoneLevelManagerType { get set }
}

class HormoneLevelManager: HormoneLevelManageable {
    private let lvlFunctions: [Ester: OneComponentBateman]
    
    init() {
        self.lvlFunctions = Ester.allCases.reduce(into: [Ester: OneComponentBateman]()) { dict, ester in
            let configuration = ester.configuration
            let bateman = OneComponentBateman(t_half: configuration.tHalf,
                                              t_max: configuration.tMax,
                                              c_max: configuration.cMax)
            dict[ester] = bateman
        }
    }
    
    func levelForInjections(_ injections: [Injection], at date: Date) -> Double {
        return injections.reduce(into: 0.0) { lvl, injection in
            guard let lvlFunction = lvlFunctions[injection.ester] else { return }
            let timeInterval = date.timeIntervalSince(injection.date) / (24 * 60  * 60)
            let scale = injection.dosage / 5.0
            let timeNormalizedConcentration = lvlFunction.getConcentrationAtTime(timeInterval) ?? 0.0
            let scaledConcentration = timeNormalizedConcentration * scale
            lvl += scaledConcentration
        }
    }
    
    func isLevelFallingForInjections(_ injections: [Injection], at date: Date) -> Bool {
        let currentLevel = levelForInjections(injections, at: date)
        let pastLevel = levelForInjections(injections, at: date.addingTimeInterval(-60 * 60)) // Check 1 hour earlier
        return pastLevel > currentLevel
    }
}

#if DEBUG
extension Mocks {
    static let hormoneLevelManager = HormoneLevelManager()
    
}
#endif
