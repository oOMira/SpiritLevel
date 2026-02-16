import SwiftUI

enum OverviewFeature: String, SearchableItem {
    case mood
    case currentLevel
    case nextInjection
    case trend
    case achivements

    var label: String {
        switch self {
        case .mood: return "Mood"
        case .currentLevel: return "Current Level"
        case .nextInjection: return "Next Injection"
        case .trend: return "Trend"
        case .achivements: return "Achivements"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .mood: "face.smiling"
        case .currentLevel: "gauge.with.needle"
        case .nextInjection: "syringe"
        case .trend: "arrow.up.right"
        case .achivements: "star"
        }
        
    }
}
