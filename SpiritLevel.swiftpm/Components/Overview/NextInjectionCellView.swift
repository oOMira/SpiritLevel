import SwiftUI

struct NextInjectionCellView: View {
    var body: some View {
        Text(Date(), format: .dateTime.month(.wide).day().year())
            .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    List {
        Section("Next Injection") {
            NextInjectionCellView()
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    List {
        Section("Next Injection") {
            NextInjectionCellView()
        }
    }
    .preferredColorScheme(.dark)
}
