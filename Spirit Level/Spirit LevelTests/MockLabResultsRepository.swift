@testable import Spirit_Level
import SwiftData
import Foundation

// MARK: - Mock LabResultsRepository

@MainActor
extension LabResultsRepository: MockableRepository {
    static var one: LabResultsRepository {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: LabResult.self, configurations: config)
        let context = ModelContext(container)
        
        let labResult = LabResult(
            concentration: 250.0,
            date: Date()
        )
        context.insert(labResult)
        try! context.save()
        
        return LabResultsRepository(modelContext: context)
    }
    
    static var tone: LabResultsRepository {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: LabResult.self, configurations: config)
        let context = ModelContext(container)
        
        let labResult1 = LabResult(
            concentration: 200.0,
            date: Date().addingTimeInterval(-30 * 24 * 60 * 60)
        )
        let labResult2 = LabResult(
            concentration: 275.0,
            date: Date()
        )
        context.insert(labResult1)
        context.insert(labResult2)
        try! context.save()
        
        return LabResultsRepository(modelContext: context)
    }
    
    static var none: LabResultsRepository {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: LabResult.self, configurations: config)
        let context = ModelContext(container)
        
        return LabResultsRepository(modelContext: context)
    }
}
