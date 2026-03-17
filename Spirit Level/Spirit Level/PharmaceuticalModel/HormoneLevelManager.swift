import Foundation

// TODO: - Find better solution!!!!

protocol HormoneLevelManageable: AnyObject {
    func levelForInjections(_ injections: [Injection], at date: Date) -> Double
    func isLevelFalling(injections: [Injection], date: Date) -> Bool?
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

protocol PlannedInjectionsManagable {
    associatedtype Dependencies: HasTreatmentPlanRepository
    var dependencies: Dependencies { get }
    func getPlannedInjectionsList(till date: Date) -> [(date: Date, plan: TreatmentPlan)]
}

// TODO: Cleanup
extension PlannedInjectionsManagable {
    func getPlannedInjectionsList(till date: Date) -> [(date: Date, plan: TreatmentPlan)] {
        let sortedtreatmentPlans = dependencies.treatmentPlanRepository.allItems
            .sorted { $0.firstInjectionDate.start < $1.firstInjectionDate.start }
        
        return (0..<sortedtreatmentPlans.count).compactMap { index in
            var currentArray = [(date: Date, plan: TreatmentPlan)]()
            
            let currentPlan = sortedtreatmentPlans[index]
            let startDate = currentPlan.firstInjectionDate.start
            let endDate = sortedtreatmentPlans.element(at: index + 1)?.firstInjectionDate.start ?? date.start
            var currentDate = startDate
            while currentDate <= endDate && currentDate <= date.start {
                currentArray.append((currentDate, currentPlan))
                currentDate = Calendar.current.date(byAdding: .day, value: currentPlan.frequency, to: currentDate) ?? .distantFuture
            }
            return currentArray
        }
        .flatMap { $0 }
    }
}
