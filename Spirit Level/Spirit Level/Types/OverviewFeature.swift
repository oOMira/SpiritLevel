import SwiftUI

enum OverviewFeature: String, CaseIterable, SearchableItem, Hashable, Identifiable {
    case reminders
    case mood
    case currentLevel
    case nextInjection
    case achievements
    
    var id: String { rawValue }
    var itemType: ItemType { .content }

    var label: String {
        switch self {
        case .reminders:        "Reminders"
        case .mood:             "Mood"
        case .currentLevel:     "Current Level"
        case .nextInjection:    "Next Injection"
        case .achievements:     "Achievements"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .reminders:        "clock"
        case .mood:             "face.smiling"
        case .currentLevel:     "gauge.with.needle"
        case .nextInjection:    "syringe"
        case .achievements:     "star"
        }
    }
}
