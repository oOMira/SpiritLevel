import SwiftUI

enum OverviewFeature: String, CaseIterable, SearchableItem, Hashable {
    case mood
    case currentLevel
    case nextInjection
    case achievements
    
    var itemType: ItemType { .content }

    var label: String {
        switch self {
        case .mood:             "Mood"
        case .currentLevel:     "Current Level"
        case .nextInjection:    "Next Injection"
        case .achievements:     "Achievements"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .mood:             "face.smiling"
        case .currentLevel:     "gauge.with.needle"
        case .nextInjection:    "syringe"
        case .achievements:     "star"
        }
    }
}
