import SwiftUI

enum AppArea: String, SearchableItem {
    case overview
    case statisitcs
    case settings

    var label: String {
        switch self {
        case .overview: return "Overview"
        case .statisitcs: return "Statistics"
        case .settings: return "Settings"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .overview: "house"
        case .statisitcs: "chart.line.uptrend.xyaxis"
        case .settings: "gearshape"
        }
    }
}
