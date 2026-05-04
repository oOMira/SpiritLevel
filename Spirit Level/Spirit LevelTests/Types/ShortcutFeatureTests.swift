import Testing
import UIKit
@testable import Spirit_Level

@Suite("ShortcutFeature Tests")
@MainActor
struct ShortcutFeatureTests {

    @Test("Identifiable")
    func testIdentifiable() {
        let ids = ShortcutFeature.allCases.map { $0.id }
        #expect(Set(ids).count == ids.count, "ShortcutFeature IDs should be unique")
    }

    @Test("Label", .tags(.resources), arguments: ShortcutFeature.allCases)
    func testLabel(_ feature: ShortcutFeature) {
        #expect(!String(localized: feature.label).isEmpty)
    }

    @Test("System Image Name", .tags(.resources), arguments: ShortcutFeature.allCases)
    func testSystemImageName(_ feature: ShortcutFeature) {
        #expect(!feature.systemImageName.isEmpty)
    }

    @Test("System Image Exists", .tags(.resources), arguments: ShortcutFeature.allCases)
    func testSystemImageExists(_ feature: ShortcutFeature) {
        #expect(UIImage(systemName: feature.systemImageName) != nil)
    }

    @Test("Item Type", arguments: ShortcutFeature.allCases)
    func testItemType(_ feature: ShortcutFeature) {
        #expect(feature.itemType == .navigation)
    }
}
