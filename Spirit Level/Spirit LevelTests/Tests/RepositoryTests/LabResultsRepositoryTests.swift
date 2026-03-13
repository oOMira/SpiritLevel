import Testing
import Foundation
import SwiftData
@testable import Spirit_Level

@MainActor
struct LabResultsRepositoryTests: ModelContextMockable {
    
    let repo = LabResultsRepository(modelContext: Self.getMockModelContext(for: LabResult.self))
    
    @Test func testEmpty() async throws {
        #expect(repo.allItems.count == 0)
    }

    @Test func testAddInjection() async throws {
        let concentration = 3.0
        let resultDate = Date()
        let result = LabResult(concentration: concentration, date: resultDate)
        try repo.add(item: result)
        #expect(repo.allItems.count == 1)
        #expect(repo.allItems.first?.concentration == concentration)
        #expect(repo.allItems.first?.date == resultDate)
    }

    @Test func testDeleteInjection() async throws {
        let result = LabResult(concentration: 3.0, date: .init())
        try repo.add(item: result)
        try repo.delete(item: result)
        #expect(repo.allItems.count == 0)
    }

    @Test func testDeleteAll() throws {
        try repo.add(item: LabResult(concentration: 3.0, date: .init()))
        try repo.add(item: LabResult(concentration: 3.0, date: .init()))
        #expect(repo.allItems.count == 2)
        try repo.deleteAll()
        #expect(repo.allItems.count == 0)
    }
}
