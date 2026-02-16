import SwiftUI

enum SettingsFeature: String, SearchableItem {
    case plan
    case support
    case data
    case deleteData
    
    var label: String {
        switch self {
        case .plan:         "Plan"
        case .support:      "Support"
        case .data:         "Data"
        case .deleteData:   "Delete Data"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .plan:         "calendar"
        case .support:      "questionmark.circle"
        case .data:         "externaldrive"
        case .deleteData:   "trash"
        }
    }
}
