import SwiftUI

struct SearchActionCellView: View {
    let configuration: Configuration

    var body: some View {
        VStack {
            configuration.image
                .font(.title)
                .padding(.top)
            Text(configuration.label)
                .font(.default)
                .padding()
        }
        .containerRelativeFrame(.horizontal,
                                count: 2,
                                spacing: 16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.gray.opacity(0.75))
        )
    }
}

extension SearchActionCellView {
    struct Configuration {
        let label: String
        let image: Image
    }
}

#Preview {
    SearchActionCellView(
        configuration: .init(
            label: "Log Injection",
            image: Image(systemName: "plus.circle.fill")
        )
    )
    .padding()
}

