@testable import Spirit_Level
import SwiftData
import Foundation

// MARK: - Mock InjectionRepository

@MainActor
extension InjectionRepository: MockableRepository {
    static var one: InjectionRepository {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Injection.self, configurations: config)
        let context = ModelContext(container)
        
        let injection = Injection(
            ester: .valerate,
            dosage: 5.0,
            date: Date()
        )
        context.insert(injection)
        try! context.save()
        
        return InjectionRepository(modelContext: context)
    }
    
    static var tone: InjectionRepository {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Injection.self, configurations: config)
        let context = ModelContext(container)
        
        let injection1 = Injection(
            ester: .valerate,
            dosage: 5.0,
            date: Date().addingTimeInterval(-7 * 24 * 60 * 60)
        )
        let injection2 = Injection(
            ester: .enanthate,
            dosage: 4.0,
            date: Date()
        )
        context.insert(injection1)
        context.insert(injection2)
        try! context.save()
        
        return InjectionRepository(modelContext: context)
    }
    
    static var none: InjectionRepository {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Injection.self, configurations: config)
        let context = ModelContext(container)
        
        return InjectionRepository(modelContext: context)
    }
}
