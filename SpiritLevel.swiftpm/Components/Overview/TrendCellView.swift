import SwiftUI

// MARK: - TrendCellView

struct TrendCellView: View {
    let configurations: [TrendView.Configuration]
    
    var body: some View {
        ForEach(configurations) { configuration in
            TrendView(configuration: configuration)
        }
    }
}

// MARK: - TrendView

struct TrendView: View, Identifiable {
    var id: UUID { configuration.id }
    let configuration: Configuration
    
    var body: some View {
        HStack {
            Text(configuration.name)
            Spacer()
            configuration.trend.image
        }
    }
}

// MARK: - TrendView+Configuration

extension TrendView {
    struct Configuration: Identifiable {
        let id = UUID()
        let name: String
        let trend: Trend
    }
}

// MARK: - Trend

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

// MARK: - Constants

private extension String {
    static let upArrow = "arrow.up.right.circle.fill"
    static let downArrow = "arrow.down.right.circle.fill"
    static let stableArrow = "arrow.right.circle.fill"
}
