import Foundation

enum Mood: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case happy
    case sad
}
