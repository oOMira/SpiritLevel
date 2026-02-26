import SwiftUI

struct InjectionsCellView: View {
    var body: some View {
        Group {
            Text(.injectionSampleData)
            Text(.injectionSampleData)
        }
        .accessibilityElement(children: .contain)
        Button(.showMoreButton) {
            print("show more injections")
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let injectionSampleData: Self = "5 mg EE on 21.01.2025"
    static let showMoreButton: Self = "Show more"
}
