import SwiftUI

struct LabResultsCellView: View {
    var body: some View {
        Group {
            Text(.labResultSampleData)
        }
        .accessibilityElement(children: .contain)
        Button(.showMoreButton) {
            print("show more lab results")
        }
    }
}

// MARK: - Constants
    

private extension LocalizedStringResource {
    static let labResultSampleData: Self = "200 pg on 21.01.2025"
    static let showMoreButton: Self = "Show more"
}
