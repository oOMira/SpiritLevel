import SwiftUI

struct InjectionsCellView: View {
    @State private var expanded: Bool = false
    var injections: [Injection]
    
    var body: some View {
        Group {
            ForEach(expanded ? injections : Array(injections.prefix(.maxInjectionsToShow))) { injection in
                Text("\(injection.dosage, specifier: .doseageFormat) mg EE on \(injection.date, format: .dateTime.day().month().year())")
            }
        }
        .accessibilityElement(children: .contain)
        Button(action: {
            withAnimation { expanded.toggle() }
        }, label: {
            AccessibleCollapseButton(expanded: $expanded)
        })
    }
}
    

// MARK: - Constants

private extension Int {
    static let maxInjectionsToShow: Self = 3
}

private extension String {
    static let doseageFormat: Self = "%.1f"
}
    
