import SwiftUI

enum StatisticsFeature: String, SearchableItem {
    case graph
    case injections
    case labResults
    
    var label: String {
        switch self {
        case .graph: return "Graph"
        case .injections: return "Injections"
        case .labResults: return "Lab Results"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .graph: "chart.xyaxis.line"
        case .injections: "cross.vial"
        case .labResults: "flask"
        }
    }
}
