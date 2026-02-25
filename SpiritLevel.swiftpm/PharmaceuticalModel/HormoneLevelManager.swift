import Foundation

struct HormoneLevelManager {
    private let injections: [OldInjection]
    private let lvlFunctions: [OneComponentBateman]
    
    var lastIterval: Double {
        let lastTwo = Array(injections.suffix(2))
        return lastTwo[1].date.timeIntervalSince(lastTwo[0].date) / 86_400
    }
    
    init(injections: [OldInjection]) {
        self.injections = injections
        self.lvlFunctions = injections.map { injection in
            let esterConfiguration = injection.ester.configuration
            return OneComponentBateman(t_half: esterConfiguration.tHalf,
                                       t_max: esterConfiguration.tMax,
                                       c_max: esterConfiguration.cMax)
        }
    }
    
    func levelForDate(_ date: Date) -> Double {
        injections.enumerated().reduce(0.0) { lvl, element in
            let (index, injection) = element
            let day = date.timeIntervalSince(injection.date) / 86_400
            let lvlFunction = lvlFunctions[index]
            return lvl + (lvlFunction.getConcentrationAtTime(day) ?? 0)
        }
    }
}
