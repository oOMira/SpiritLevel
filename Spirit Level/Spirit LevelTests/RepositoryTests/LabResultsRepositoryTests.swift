import Testing
import Foundation
import SwiftData
@testable import Spirit_Level

@Suite("Lab Results Repository", .tags(.swiftData, .labResults, .repository))
@MainActor
struct LabResultsRepositoryTests: ModelContextMockable {

    let repo = LabResultsRepository(modelContext: Self.getMockModelContext(for: LabResult.self))

    @Test("No lab results logged")
    func testEmpty() async throws {
        #expect(repo.allItems.count == 0, "LabResultsRepository should return no lab results when empty")
    }

    @Test("Log one lab result")
    func testAddInjection() async throws {
        let concentration = 3.0
        let resultDate = Date()
        let result = LabResult(concentration: concentration, date: resultDate)
        try repo.add(item: result)
        #expect(repo.allItems.count == 1, "LabResultsRepository should return one logged lab result after add")
        #expect(repo.allItems.first?.concentration == concentration, "LabResultsRepository should return set concentration after add")
        #expect(repo.allItems.first?.date == resultDate, "LabResultsRepository should return set date after add")
    }

    @Test("Log many lab results")
    func testAddManyLabResults() throws {
        let firstStoredDate = Date.now
        let secondStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -1, to: firstStoredDate))
        let thirdStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -2, to: firstStoredDate))
        let fourthStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -3, to: firstStoredDate))
        let fifthStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -4, to: firstStoredDate))
        let sixthStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -5, to: firstStoredDate))
        let results = [
            LabResult(concentration: 1.0, date: firstStoredDate),
            LabResult(concentration: 2.5, date: secondStoredDate),
            LabResult(concentration: 4.0, date: thirdStoredDate),
            LabResult(concentration: 5.5, date: fourthStoredDate),
            LabResult(concentration: 7.0, date: fifthStoredDate),
            LabResult(concentration: 8.5, date: sixthStoredDate)
        ]
        for result in results {
            try repo.add(item: result)
        }
        #expect(repo.allItems.count == results.count, "LabResultsRepository should return all logged lab results after multiple adds")
        results.forEach { result in
            #expect(
                repo.allItems.contains(where: {
                    $0.concentration == result.concentration &&
                    $0.date == result.date
                }),
                "LabResultsRepository should contain logged lab result concentration=\(result.concentration), date=\(result.date.timeIntervalSinceReferenceDate)"
            )
        }
    }

    @Test("Delete one lab result")
    func testDeleteInjection() async throws {
        let result = LabResult(concentration: 3.0, date: .init())
        try repo.add(item: result)
        try repo.delete(item: result)
        #expect(repo.allItems.count == 0, "LabResultsRepository should return no lab results after delete")
    }

    @Test("Deletes all lab results")
    func testDeleteAll() throws {
        try repo.add(item: LabResult(concentration: 3.0, date: .init()))
        try repo.add(item: LabResult(concentration: 3.0, date: .init()))
        #expect(repo.allItems.count == 2, "LabResultsRepository should return all logged lab results before deleteAll")
        try repo.deleteAll()
        #expect(repo.allItems.count == 0, "LabResultsRepository should return no lab results after deleteAll")
    }
}
