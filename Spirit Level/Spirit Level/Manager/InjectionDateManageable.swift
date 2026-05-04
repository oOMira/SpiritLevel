import Foundation

typealias InjectionDateManagerDependencies = HasInjectionRepository & HasTreatmentPlanRepository

@MainActor
protocol InjectionDateManageable: AnyObject, Observable {
    associatedtype Dependencies: InjectionDateManagerDependencies
    var dependencies: Dependencies { get }
    func getNextInjectionDate(until date: Date) -> Date?
    func getPlannedInjectionsList(until date: Date) -> [(date: Date, plan: TreatmentPlan)]
}

extension InjectionDateManageable {
    func getNextInjectionDate(until date: Date) -> Date? {
        let startDate = date.start

        let latestPlan = dependencies.treatmentPlanRepository.allItems
            .sorted { $0.firstInjectionDate.start > $1.firstInjectionDate.start }
            .first

        guard let latestPlan else { return nil }

        guard latestPlan.firstInjectionDate.start <= startDate else {
            return latestPlan.firstInjectionDate.start
        }

        let lastPlannedDateUntilNow = getPlannedInjectionsList(until: date)
            .sorted { $0.date.start > $1.date.start }
            .first

        let lastInjection = dependencies.injectionRepository.allItems
            .sorted { $0.date.start > $1.date.start }
            .first

        guard let lastPlannedDateUntilNow else { return startDate }
        guard let lastInjectionDate = lastInjection?.date.start else {
            return latestPlan.firstInjectionDate.start
        }
        guard let nextInjectionDate = Calendar.current.date(
            byAdding: .day,
            value: latestPlan.frequency,
            to: lastPlannedDateUntilNow.date.start
        ) else { return startDate }

        let loggedLastInjection = lastPlannedDateUntilNow.date.start <= lastInjectionDate
        return loggedLastInjection ? nextInjectionDate : lastPlannedDateUntilNow.date
    }

    func getPlannedInjectionsList(until date: Date) -> [(date: Date, plan: TreatmentPlan)] {
        let sortedTreatmentPlans = dependencies.treatmentPlanRepository.allItems
            .sorted { $0.firstInjectionDate.start < $1.firstInjectionDate.start }

        return (0..<sortedTreatmentPlans.count).compactMap { index in
            var currentArray = [(date: Date, plan: TreatmentPlan)]()

            let currentPlan = sortedTreatmentPlans[index]
            let startDate = currentPlan.firstInjectionDate.start
            let endDate = sortedTreatmentPlans.element(at: index + 1)?.firstInjectionDate.start
                ?? date.start
            var currentDate = startDate
            while currentDate <= endDate && currentDate <= date.start {
                currentArray.append((currentDate, currentPlan))
                currentDate = Calendar.current.date(
                    byAdding: .day,
                    value: currentPlan.frequency,
                    to: currentDate
                ) ?? .distantFuture
            }
            return currentArray
        }
        .flatMap { $0 }
    }
}
