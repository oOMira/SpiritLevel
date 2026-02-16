import SwiftUI

enum SettingsFeature: String, SearchableItem {
    case plan
    case support
    case data
    case deleteData
    
    var label: String {
        switch self {
        case .plan: return "Plan"
        case .support: return "Support"
        case .data: return "Data"
        case .deleteData: return "Delete Data"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .plan: "calendar"
        case .support: "questionmark.circle"
        case .data: "externaldrive"
        case .deleteData: "trash"
        }
    }
}
