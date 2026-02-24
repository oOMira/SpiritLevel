import SwiftUI

enum ShortcutFeature: String, SearchableItem {
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
    
    // TODO: Add mapping
    var view: any View {
        Text(self.label)
    }
}

