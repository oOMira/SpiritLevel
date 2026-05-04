import SwiftUI

enum Trend: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case rising
    case falling
    case stable
    case unclear

    var image: Image {
        switch self {
        case .falling: .init(systemName: .downArrow)
        case .rising: .init(systemName: .upArrow)
        case .stable: .init(systemName: .stableArrow)
        case .unclear: .init(systemName: .questionMark)
        }
    }
}

private extension String {
    static let upArrow = "arrow.up.right.circle.fill"
    static let downArrow = "arrow.down.right.circle.fill"
    static let stableArrow = "arrow.right.circle.fill"
    static let questionMark = "questionmark.circle.fill"
}
