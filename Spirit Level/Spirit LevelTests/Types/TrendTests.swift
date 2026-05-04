import Testing
import Foundation
@testable import Spirit_Level

@Suite("Trend Tests")
@MainActor
struct TrendTests {

    @Test("Identifiable")
    func testIdentifiable() {
        let ids = Trend.allCases.map { $0.id }
        #expect(Set(ids).count == ids.count, "Trend IDs should be unique")
    }
}
