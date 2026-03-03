import Foundation

extension Ester {
    func predefinedStablePlan(date: Date = .now) -> TreatmentPlan {
        // TODO: evaluate it is assumed that you reach a stable state after 10 times the half life
        let timeTillStable = configuration.tHalf * 10
        let daysToStable = Int(timeTillStable.rounded(.up))
        let stableDate = Calendar.current.date(byAdding: .day, value: -daysToStable, to: date) ?? date
        
        return .init(name: "Predefined \(name)",
                     ester: self,
                     frequency: defaultRhythm,
                     dosage: defaultDose,
                     firstInjectionDate: stableDate)
    }
    
    func predefinedFirstInjectionPlan(date: Date = .now) -> TreatmentPlan {
        .init(name: "Predefined \(name)",
              ester: self,
              frequency: defaultRhythm,
              dosage: defaultDose,
              firstInjectionDate: date)
    }
}
