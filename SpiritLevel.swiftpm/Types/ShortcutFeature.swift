import SwiftUI

enum ShortcutFeature: String, SearchableItem, CaseIterable {
    case logLab
    case logInjection
    
    var label: String {
        switch self {
        case .logLab:       "Log Lab Result"
        case .logInjection: "Log Injection"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .logLab:       "heart.text.clipboard"
        case .logInjection: "syringe"
        }
    }
}

