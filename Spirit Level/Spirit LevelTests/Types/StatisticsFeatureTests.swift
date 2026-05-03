import Testing
import UIKit
@testable import Spirit_Level

@Suite("StatisticsFeature Tests")
@MainActor
struct StatisticsFeatureTests {
    
    @Test("Identifiable")
    func testIdentifiable() {
        let ids = StatisticsFeature.allCases.map { $0.id }
        #expect(Set(ids).count == ids.count, "StatisticsFeature IDs should be unique")
    }
    
    @Test("Label", .tags(.resources), arguments: StatisticsFeature.allCases)
    func testLabel(_ feature: StatisticsFeature) {
        #expect(!String(localized: feature.label).isEmpty)
    }
    
    @Test("System Image Name", .tags(.resources), arguments: StatisticsFeature.allCases)
    func testSystemImageName(_ feature: StatisticsFeature) {
        #expect(!feature.systemImageName.isEmpty)
    }
    
    @Test("System Image Exists", .tags(.resources), arguments: StatisticsFeature.allCases)
    func testSystemImageExists(_ feature: StatisticsFeature) {
        #expect(UIImage(systemName: feature.systemImageName) != nil)
    }
    
    @Test("Item Type", arguments: StatisticsFeature.allCases)
    func testItemType(_ feature: StatisticsFeature) {
        #expect(feature.itemType == .content)
    }
}
