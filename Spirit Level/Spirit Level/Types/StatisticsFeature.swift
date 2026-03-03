import SwiftUI

enum StatisticsFeature: String, CaseIterable, SearchableItem {
    case injections
    case labResults
    
    var itemType: ItemType { .content }
    
    var label: String {
        switch self {
        case .injections:   "Injections"
        case .labResults:   "Lab Results"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .injections:   "cross.vial"
        case .labResults:   "flask"
        }
    }
}
