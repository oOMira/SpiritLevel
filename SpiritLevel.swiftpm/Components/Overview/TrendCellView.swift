import SwiftUI

struct TrendCellView: View {
    let name: String
    let trend: Trend
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            trend.image
        }
    }
}

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
    static let upArrow =        "arrow.up.right.circle.fill"
    static let downArrow =      "arrow.down.right.circle.fill"
    static let stableArrow =    "arrow.right.circle.fill"
}


// MARK: Preview

#Preview {
    List {
        TrendCellView(name: "Focus", trend: .up)
        TrendCellView(name: "Energy", trend: .down)
        TrendCellView(name: "Mood", trend: .stable)
    }
    .listStyle(.plain)
}
