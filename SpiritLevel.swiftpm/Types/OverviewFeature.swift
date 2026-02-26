import SwiftUI

enum OverviewFeature: String, CaseIterable, SearchableItem {
    case mood
    case currentLevel
    case nextInjection
    case trend
    case achivements
    
    var itemType: ItemType { .content }

    var label: String {
        switch self {
        case .mood:             "Mood"
        case .currentLevel:     "Current Level"
        case .nextInjection:    "Next Injection"
        case .trend:            "Trend"
        case .achivements:      "Achievements"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .mood:             "face.smiling"
        case .currentLevel:     "gauge.with.needle"
        case .nextInjection:    "syringe"
        case .trend:            "arrow.up.right"
        case .achivements:      "star"
        }
    }
}
