import Foundation

// TODO: Add different moods
enum Mood: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case happy
    case sad
    case unclear
}
