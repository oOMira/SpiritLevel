import SwiftUI

enum StatisticsFeature: String, CaseIterable, SearchableItem {
    case graph
    case injections
    case labResults
    
    var itemType: ItemType { .content }
    
    var label: String {
        switch self {
        case .graph:        "Graph"
        case .injections:   "Injections"
        case .labResults:   "Lab Results"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .graph:        "chart.xyaxis.line"
        case .injections:   "cross.vial"
        case .labResults:   "flask"
        }
    }
}
