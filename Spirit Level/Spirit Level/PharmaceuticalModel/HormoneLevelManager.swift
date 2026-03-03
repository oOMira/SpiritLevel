import Foundation

protocol HormoneLevelManageable: AnyObject {
    func levelForInjections(_ injections: [Injection], at date: Date) -> Double
    func isLevelFalling(injections: [Injection], date: Date) -> Bool?
}

// TODO: Better handling for 0
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
            let timeInterval = date.timeIntervalSince(injection.date) / .magicNumbers.daysInSeconds
            let scale = injection.dosage / 5.0
            let timeNormalizedConcentration = lvlFunction.getConcentrationAtTime(timeInterval) ?? 0.0
            let scaledConcentration = timeNormalizedConcentration * scale
            lvl += scaledConcentration
        }
    }
    
    func isLevelFalling(injections: [Injection], date: Date) -> Bool? {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
        let lvlNow = levelForInjections(injections, at: date)
        let lvlTomorrow = levelForInjections(injections, at: tomorrow)
        guard lvlNow != 0 || lvlTomorrow != 0 else { return nil }
        return lvlNow > lvlTomorrow
    }
}
