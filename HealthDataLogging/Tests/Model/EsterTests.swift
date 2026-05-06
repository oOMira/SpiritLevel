import Testing
import HealthDataLogging
import SpiritLevelSharedTesting
import Foundation

@Suite("Ester Tests")
@MainActor
struct EsterTests {

    @Test("Identifiable")
    func testIdentifiable() {
        let ids = Ester.allCases.map { $0.id }
        #expect(Set(ids).count == ids.count, "Ester IDs should be unique")
    }

    @Test("Name", .tags(.resources), arguments: Ester.allCases)
    func testName(_ ester: Ester) {
        #expect(!ester.name.isEmpty)
    }

    @Test("Short Name", .tags(.resources), arguments: Ester.allCases)
    func testShortName(_ ester: Ester) {
        #expect(!ester.shortName.isEmpty)
    }

    @Test("Configuration", arguments: Ester.allCases)
    func testConfiguration(_ ester: Ester) {
        let config = ester.configuration
        #expect(!config.name.isEmpty, "\(ester) configuration name should not be empty")
        #expect(config.cMax > 0, "\(ester) cMax should be positive")
        #expect(config.tMax > 0, "\(ester) tMax should be positive")
        #expect(config.tHalf > 0, "\(ester) tHalf should be positive")
    }

    @Test("Default Dose", arguments: Ester.allCases)
    func testDefaultDose(_ ester: Ester) {
        #expect(ester.defaultDose > 0, "\(ester) default dose should be positive")
    }

    @Test("Default Rhythm", arguments: Ester.allCases)
    func testDefaultRhythm(_ ester: Ester) {
        #expect(ester.defaultRhythm > 0, "\(ester) default rhythm should be positive")
    }
}
