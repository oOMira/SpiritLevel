import SwiftUI

enum AppArea: String, CaseIterable, SearchableItem {
    case overview
    case statistics
    case settings
    
    var itemType: ItemType { .navigation }

    var label: LocalizedStringResource {
        switch self {
        case .overview: "Overview"
        case .statistics: "Statistics"
        case .settings: "Settings"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .overview: "house"
        case .statistics: "chart.bar.xaxis"
        case .settings: "gearshape"
        }
    }
}
