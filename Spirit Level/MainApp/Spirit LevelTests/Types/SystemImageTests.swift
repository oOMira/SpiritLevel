import Testing
import UIKit
@testable import Spirit_Level

@Suite("SystemImage Tests")
@MainActor
struct SystemImageTests {
    @Test("Name", .tags(.resources), arguments: SystemImage.allCases)
    func testName(_ systemImage: SystemImage) {
        #expect(!systemImage.name.isEmpty)
    }

    @Test("Image Exists", .tags(.resources), arguments: SystemImage.allCases)
    func testImageExists(_ systemImage: SystemImage) {
        #expect(UIImage(systemName: systemImage.name) != nil)
    }
}
