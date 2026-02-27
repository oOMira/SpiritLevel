import SwiftUI

struct InjectionsCellView: View {
    var injections: [Injection]
    
    var body: some View {
        Group {
            ForEach(injections) { injection in
                Text("\(injection.dosage, specifier: .doseageFormat) mg EE on \(injection.date, format: .dateTime.day().month().year())")
            }
        }
        .accessibilityElement(children: .contain)
        Button(.showMoreButton) {
            print("show more injections")
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let showMoreButton: Self = "Show more"
}

private extension String {
    static let doseageFormat: Self = "%.1f"
}
    
