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
