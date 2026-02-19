import SwiftUI

enum AppArea: String, SearchableItem {
    case overview
    case statisitcs
    case settings

    var label: String {
        switch self {
        case .overview:     "Overview"
        case .statisitcs:   "Statistics"
        case .settings:     "Settings"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .overview:     "house"
        case .statisitcs:   "chart.bar.xaxis"
        case .settings:     "gearshape"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .overview:     .red
        case .statisitcs:   .green
        case .settings:     .blue
        }
    }
}
