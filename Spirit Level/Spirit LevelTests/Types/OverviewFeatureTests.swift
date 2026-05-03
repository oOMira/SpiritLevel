import Testing
import UIKit
@testable import Spirit_Level

@Suite("OverviewFeature Tests")
@MainActor
struct OverviewFeatureTests {
    
    @Test("Identifiable")
    func testIdentifiable() {
        let ids = OverviewFeature.allCases.map { $0.id }
        #expect(Set(ids).count == ids.count, "OverviewFeature IDs should be unique")
    }
    
    @Test("Label", .tags(.resources), arguments: OverviewFeature.allCases)
    func testLabel(_ feature: OverviewFeature) {
        #expect(!String(localized: feature.label).isEmpty)
    }
    
    @Test("System Image Name", .tags(.resources), arguments: OverviewFeature.allCases)
    func testSystemImageName(_ feature: OverviewFeature) {
        #expect(!feature.systemImageName.isEmpty)
    }
    
    @Test("System Image Exists", .tags(.resources), arguments: OverviewFeature.allCases)
    func testSystemImageExists(_ feature: OverviewFeature) {
        #expect(UIImage(systemName: feature.systemImageName) != nil)
    }
    
    @Test("Item Type", arguments: OverviewFeature.allCases)
    func testOverview(_ feature: OverviewFeature) {
        #expect(feature.itemType == .content)
    }
}
