import SwiftUI

// systemImageName is done by AI and just fine tuned by me

enum AppArea: String, CaseIterable, SearchableItem {
    case overview
    case statistics
    case settings
    
    var itemType: ItemType { .navigation }

    var localizedLabel: LocalizedStringResource {
        switch self {
        case .overview:     "Overview"
        case .statistics:   "Statistics"
        case .settings:     "Settings"
        }
    }
    
    var label: String { String(localized: localizedLabel) }
    
    var systemImageName: String {
        switch self {
        case .overview:     "house"
        case .statistics:   "chart.bar.xaxis"
        case .settings:     "gearshape"
        }
    }
    
    // TODO: move to private extension
    
    var accentColor: Color {
        switch self {
        case .overview:     .red
        case .statistics:   .green
        case .settings:     .blue
        }
    }
}

