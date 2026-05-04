import Testing
import UIKit
@testable import Spirit_Level

@Suite("AppArea Tests")
@MainActor
struct AppAreaTests {

    @Test("Identifiable")
    func testIdentifiable() {
        let ids = AppArea.allCases.map { $0.id }
        #expect(Set(ids).count == ids.count, "AppArea IDs should be unique")
    }

    @Test("Label", .tags(.resources), arguments: AppArea.allCases)
    func testLabel(_ area: AppArea) {
        #expect(!String(localized: area.label).isEmpty)
    }

    @Test("System Image Name", .tags(.resources), arguments: AppArea.allCases)
    func testSystemImageName(_ area: AppArea) {
        #expect(!area.systemImageName.isEmpty)
    }

    @Test("System Image Exists", .tags(.resources), arguments: AppArea.allCases)
    func testSystemImageExists(_ area: AppArea) {
        #expect(UIImage(systemName: area.systemImageName) != nil)
    }

    @Test("Item Type", arguments: AppArea.allCases)
    func testArea(_ area: AppArea) {
        #expect(area.itemType == .navigation)
    }
}
