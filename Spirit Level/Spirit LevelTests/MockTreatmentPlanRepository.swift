@testable import Spirit_Level
import SwiftData
import Foundation

// MARK: - Mock TreatmentPlanRepository

@MainActor
extension TreatmentPlanRepository: MockableRepository {
    static var one: TreatmentPlanRepository {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: TreatmentPlan.self, configurations: config)
        let context = ModelContext(container)
        
        let treatmentPlan = TreatmentPlan(
            name: "Standard Plan",
            ester: .valerate,
            frequency: 7,
            dosage: 5.0,
            firstInjectionDate: Date()
        )
        context.insert(treatmentPlan)
        try! context.save()
        
        return TreatmentPlanRepository(modelContext: context)
    }
    
    static var tone: TreatmentPlanRepository {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: TreatmentPlan.self, configurations: config)
        let context = ModelContext(container)
        
        let treatmentPlan1 = TreatmentPlan(
            name: "Old Plan",
            ester: .enanthate,
            frequency: 10,
            dosage: 4.0,
            firstInjectionDate: Date().addingTimeInterval(-90 * 24 * 60 * 60)
        )
        let treatmentPlan2 = TreatmentPlan(
            name: "Current Plan",
            ester: .valerate,
            frequency: 7,
            dosage: 5.0,
            firstInjectionDate: Date()
        )
        context.insert(treatmentPlan1)
        context.insert(treatmentPlan2)
        try! context.save()
        
        return TreatmentPlanRepository(modelContext: context)
    }
    
    static var none: TreatmentPlanRepository {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: TreatmentPlan.self, configurations: config)
        let context = ModelContext(container)
        
        return TreatmentPlanRepository(modelContext: context)
    }
}
