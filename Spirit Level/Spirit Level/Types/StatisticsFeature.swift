import SwiftUI

enum StatisticsFeature: String, CaseIterable, SearchableItem {
    case chart
    case injections
    case labResults
    case history
    case trends
    
    var itemType: ItemType { .content }
    
    var label: String {
        switch self {
        case .chart: "Hormone Level Chart"
        case .injections: "Injections"
        case .labResults: "Lab Results"
        case .trends: "Trends"
        case .history: "History"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .chart: "chart.line.uptrend.xyaxis"
        case .injections: "cross.vial"
        case .labResults: "flask"
        case .trends: "chart.line.uptrend.xyaxis"
        case .history: "clock"
        }
    }
}
