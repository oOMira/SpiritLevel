import SwiftUI

enum Trend: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case up
    case down
    case stable
    
    var image: Image {
        switch self {
        case .down:     .init(systemName: .downArrow)
        case .up:       .init(systemName: .upArrow)
        case .stable:   .init(systemName: .stableArrow)
        }
    }
}

private extension String {
    static let upArrow = "arrow.up.right.circle.fill"
    static let downArrow = "arrow.down.right.circle.fill"
    static let stableArrow = "arrow.right.circle.fill"
}
