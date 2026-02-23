import SwiftUI

struct SearchResultCellView: View {
    let label: String
    let image: Image

    var body: some View {
        HStack {
            image
            Text(label)
        }
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    List {
        SearchResultCellView(label: "Overview", image: Image(systemName: "house"))
        SearchResultCellView(label: "Settings", image: Image(systemName: "gear"))
        SearchResultCellView(label: "Statistics", image: Image(systemName: "chart.bar"))
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    List {
        SearchResultCellView(label: "Overview", image: Image(systemName: "house"))
        SearchResultCellView(label: "Settings", image: Image(systemName: "gear"))
        SearchResultCellView(label: "Statistics", image: Image(systemName: "chart.bar"))
    }
    .preferredColorScheme(.dark)
}
