import Testing
import Foundation
@testable import Spirit_Level

@Suite("Mood Tests")
@MainActor
struct MoodTests {
    
    @Test("Identifiable")
    func testIdentifiable() {
        let ids = Mood.allCases.map { $0.id }
        #expect(Set(ids).count == ids.count, "Mood IDs should be unique")
    }
}
