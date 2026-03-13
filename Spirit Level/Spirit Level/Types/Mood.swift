import Foundation

/// The mood associated with the current hormone levels at a certain point in time
enum Mood: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    /// Hormone levels are typically associated with a happy mood
    case happy
    /// Hormone levels are typically associated with a sad mood
    case sad
    /// Hormone levels are typically associated with a pouting mood
    case pouting
    /// Hormone levels are typically associated with a confident mood
    case confident
    /// Used when no clear trend could be identified
    /// e.g. your levels from the last injections are falling faster than the levels from the latest injection are rising
    case unsure
    /// Used when no mood could be estimated
    case unclear
}
