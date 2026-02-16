import SwiftUI

enum ShortcutFeature: String, SearchableItem {
    case logInjection
    case logLab
    
    var label: String {
        switch self {
        case .logInjection: "Log Injection"
        case .logLab:       "Log Lab Result"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .logInjection: "syringe"
        case .logLab:       "heart.text.clipboard"
        }
    }
}

