import Testing
import UIKit
@testable import Spirit_Level

@Suite("SettingsFeature Tests")
@MainActor
struct SettingsFeatureTests {

    @Test("Identifiable")
    func testIdentifiable() {
        let ids = SettingsFeature.allCases.map { $0.id }
        #expect(Set(ids).count == ids.count, "SettingsFeature IDs should be unique")
    }

    @Test("Label", .tags(.resources), arguments: SettingsFeature.allCases)
    func testLabel(_ feature: SettingsFeature) {
        #expect(!String(localized: feature.label).isEmpty)
    }

    @Test("System Image Name", .tags(.resources), arguments: SettingsFeature.allCases)
    func testSystemImageName(_ feature: SettingsFeature) {
        #expect(!feature.systemImageName.isEmpty)
    }

    @Test("System Image Exists", .tags(.resources), arguments: SettingsFeature.allCases)
    func testSystemImageExists(_ feature: SettingsFeature) {
        #expect(UIImage(systemName: feature.systemImageName) != nil)
    }

    @Test("Item Type", arguments: SettingsFeature.allCases)
    func testItemType(_ feature: SettingsFeature) {
        #expect(feature.itemType == .content)
    }
}
