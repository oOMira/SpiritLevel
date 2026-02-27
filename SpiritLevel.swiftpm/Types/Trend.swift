import SwiftUI

// TODO: Used for future statistics features.
enum Trend: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case up
    case down
    case stable
    case unclear
    
    var image: Image {
        switch self {
        case .down:     .init(systemName: .downArrow)
        case .up:       .init(systemName: .upArrow)
        case .stable:   .init(systemName: .stableArrow)
        case .unclear:  .init(systemName: .questionMark)
        }
    }
}

private extension String {
    static let upArrow = "arrow.up.right.circle.fill"
    static let downArrow = "arrow.down.right.circle.fill"
    static let stableArrow = "arrow.right.circle.fill"
    static let questionMark = "questionmark.circle.fill"
}
