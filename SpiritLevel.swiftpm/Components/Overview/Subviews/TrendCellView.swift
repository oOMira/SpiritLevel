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
        .accessibilityElement(children: .combine)
        .accessibilityValue(configuration.trend.rawValue)
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
