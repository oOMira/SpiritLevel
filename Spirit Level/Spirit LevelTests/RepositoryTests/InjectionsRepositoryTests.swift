import Testing
import Foundation
import SwiftData
@testable import Spirit_Level

@Suite("Injections Repository", .tags(.swiftData, .repository, .injections))
@MainActor
struct InjectionsRepositoryTests: ModelContextMockable {
    let repo = InjectionRepository(modelContext: Self.getMockModelContext(for: Injection.self))

    @Test("No injection logged")
    func testEmpty() async throws {
        #expect(repo.allItems.count == 0, "InjectionRepository should return no injections when empty")
    }

    @Test("Log one injection")
    func testAddInjection() throws {
        let ester = Ester.valerate
        let dosage = 5.0
        let date = Date()
        let injection = Injection(ester: ester, dosage: dosage, date: date)
        try repo.add(item: injection)
        #expect(repo.allItems.count == 1, "InjectionRepository should return one logged injection after add")
        #expect(repo.allItems.first?.dosage == dosage, "InjectionRepository should return set dosage after add")
        #expect(repo.allItems.first?.ester == ester, "InjectionRepository should return set ester after add")
        #expect(repo.allItems.first?.date == date, "InjectionRepository should return set date after add")
    }

    @Test("Log many injections")
    func testAddManyInjections() throws {
        let firstStoredDate = Date.now
        let secondStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -1, to: firstStoredDate))
        let thirdStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -2, to: firstStoredDate))
        let fourthStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -3, to: firstStoredDate))
        let fifthStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -4, to: firstStoredDate))
        let sixthStoredDate = try #require(Calendar.current.date(byAdding: .day, value: -5, to: firstStoredDate))
        let injections = [
            Injection(ester: .valerate, dosage: 5.0, date: firstStoredDate),
            Injection(ester: .enanthate, dosage: 3.0, date: secondStoredDate),
            Injection(ester: .valerate, dosage: 4.0, date: thirdStoredDate),
            Injection(ester: .enanthate, dosage: 2.0, date: fourthStoredDate),
            Injection(ester: .valerate, dosage: 6.0, date: fifthStoredDate),
            Injection(ester: .enanthate, dosage: 1.5, date: sixthStoredDate)
        ]
        for injection in injections {
            try repo.add(item: injection)
        }
        #expect(repo.allItems.count == injections.count, "InjectionRepository should return all logged injections after multiple adds")
        injections.forEach { injection in
            #expect(
                repo.allItems.contains(where: {
                    $0.ester == injection.ester &&
                    $0.dosage == injection.dosage &&
                    $0.date == injection.date
                }),
                "InjectionRepository should contain logged injection ester=\(injection.ester.rawValue), dosage=\(injection.dosage), date=\(injection.date.timeIntervalSinceReferenceDate)"
            )
        }
    }

    @Test("Delete one injection")
    func testDeleteInjection() throws {
        let injection = Injection(ester: .enanthate, dosage: 3.0, date: Date())
        try repo.add(item: injection)
        try repo.delete(item: injection)
        #expect(repo.allItems.count == 0, "InjectionRepository should return no injections after delete")
    }

    @Test("Test delete all injections")
    func testDeleteAll() throws {
        try repo.add(item: Injection(ester: .valerate, dosage: 5.0, date: Date()))
        try repo.add(item: Injection(ester: .enanthate, dosage: 3.0, date: Date()))
        #expect(repo.allItems.count == 2, "InjectionRepository should return all logged injections before deleteAll")
        try repo.deleteAll()
        #expect(repo.allItems.count == 0, "InjectionRepository should return no injections after deleteAll")
    }
}
