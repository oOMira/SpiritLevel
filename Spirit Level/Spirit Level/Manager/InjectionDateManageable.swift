import Foundation

typealias InjectionPlannerManagerDependencies = HasInjectionRepository & HasTreatmentPlanRepository

@MainActor
protocol InjectionDateManageable: AnyObject, Observable {
    associatedtype Dependencies: InjectionPlannerManagerDependencies
    var dependencies: Dependencies { get }
    func getNextInjectionDate(till date: Date) -> Date?
    func getPlannedInjectionsList(till date: Date) -> [(date: Date, plan: TreatmentPlan)]
}

extension InjectionDateManageable {
    func getNextInjectionDate(till date: Date) -> Date? {
        let startDate = date.start
        
        let latestPlan = dependencies.treatmentPlanRepository.allItems
            .sorted { $0.firstInjectionDate.start > $1.firstInjectionDate.start }
            .first
        
        guard let latestPlan else { return nil }

        guard latestPlan.firstInjectionDate.start <= startDate else { return latestPlan.firstInjectionDate.start }
        
        let lastPlannedDateTillNow = getPlannedInjectionsList(till: date)
            .sorted { $0.date.start > $1.date.start }
            .first
        
        let lastInjection = dependencies.injectionRepository.allItems
            .sorted { $0.date.start > $1.date.start }
            .first
                    
        guard let lastPlannedDateTillNow else { return startDate }
        guard let lastInjectionDate = lastInjection?.date.start else { return latestPlan.firstInjectionDate.start }
        guard let nextInjectionDate = Calendar.current.date(byAdding: .day,
                                                            value: latestPlan.frequency,
                                                            to: lastPlannedDateTillNow.date.start) else { return startDate }
        
        let loggedLastInjection = lastPlannedDateTillNow.date.start <= lastInjectionDate
        return loggedLastInjection ? nextInjectionDate : lastPlannedDateTillNow.date
    }
    
    // TODO: Clean up
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
