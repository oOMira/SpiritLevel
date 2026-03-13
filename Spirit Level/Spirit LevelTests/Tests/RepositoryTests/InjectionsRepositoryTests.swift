import Testing
import Foundation
import SwiftData
@testable import Spirit_Level

@MainActor
struct InjectionsRepositoryTests: ModelContextMockable {
    let repo = InjectionRepository(modelContext: Self.getMockModelContext(for: Injection.self))
    
    @Test func testEmpty() async throws {
        #expect(repo.allItems.count == 0)
    }

    @Test func testAddInjection() throws {
        let ester = Ester.valerate
        let dosage = 5.0
        let date = Date()
        let injection = Injection(ester: ester, dosage: dosage, date: date)
        try repo.add(item: injection)
        #expect(repo.allItems.count == 1)
        #expect(repo.allItems.first?.dosage == dosage)
        #expect(repo.allItems.first?.ester == ester)
        #expect(repo.allItems.first?.date == date)
    }

    @Test func testDeleteInjection() throws {
        let injection = Injection(ester: .enanthate, dosage: 3.0, date: Date())
        try repo.add(item: injection)
        try repo.delete(item: injection)
        #expect(repo.allItems.count == 0)
    }

    @Test func testDeleteAll() throws {
        try repo.add(item: Injection(ester: .valerate, dosage: 5.0, date: Date()))
        try repo.add(item: Injection(ester: .enanthate, dosage: 3.0, date: Date()))
        #expect(repo.allItems.count == 2)
        try repo.deleteAll()
        #expect(repo.allItems.count == 0)
    }
}
