import Foundation

protocol HormoneLevelManagable: AnyObject {
    func levelForDate(_ date: Date) -> Double
}

@MainActor
struct HormoneLevelManager {
    private let lvlFunctions: [Ester: OneComponentBateman]
    
    init(injections: [Injection]) {
        self.lvlFunctions = Ester.allCases.reduce(into: [Ester: OneComponentBateman]()) { dict, ester in
            let configuraiton = ester.configuration
            let bateman = OneComponentBateman(t_half: configuraiton.tHalf,
                                              t_max: configuraiton.tMax,
                                              c_max: configuraiton.cMax)
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
}
