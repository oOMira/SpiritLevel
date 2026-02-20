import SwiftUI

enum StatisticsFeature: String, SearchableItem {
    case graph
    case injections
    case labResults
    
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
    
    // TODO: Add mapping
    var view: any View {
        Text(self.label)
    }
}
