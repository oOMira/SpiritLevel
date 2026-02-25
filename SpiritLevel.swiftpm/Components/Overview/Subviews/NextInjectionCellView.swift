import SwiftUI

struct NextInjectionCellView: View {
    var body: some View {
        Text(Date(), format: .dateTime.month(.wide).day().year())
            .accessibilityElement(children: .combine)
    }
}
