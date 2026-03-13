import SwiftUI

struct SearchResultCellView: View {
    let label: LocalizedStringResource
    let image: Image

    var body: some View {
        HStack {
            image
            Text(label)
        }
    }
}
// MARK: - Previews

#Preview("Light Mode") {
    List {
        SearchResultCellView(label: "Overview", image: Image(systemName: "house"))
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    List {
        SearchResultCellView(label: "Overview", image: Image(systemName: "house"))
    }
    .preferredColorScheme(.dark)
}
