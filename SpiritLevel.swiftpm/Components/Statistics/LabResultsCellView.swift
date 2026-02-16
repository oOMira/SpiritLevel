import SwiftUI

struct LabResultsCellView<LabResultsRepositoryType: LabResultsManageable>: View {
    @State private var showsDeleteError: Bool = false
    @State private var expanded = false
    let labResultsRepository: LabResultsRepositoryType
    
    var body: some View {
        let labResults = labResultsRepository.allItems
        let displayedLabResults = expanded ? labResults : Array(labResults.prefix(.maxInjectionsToShow))
        
        Group {
            if labResults.isEmpty {
                Text(.noLabResultsHint)
            } else {
                ForEach(displayedLabResults) { labResult in
                    Text("\(labResult.concentration.formatted(.number.precision(.fractionLength(0)))) pg on \(labResult.date, format: .dateTime.day().month().year())")
                }
                .onDelete { offsets in
                    offsets.forEach {
                        do {
                            try labResultsRepository.delete(item: displayedLabResults[$0])
                        } catch {
                            showsDeleteError.toggle()
                        }
                    }
                }
            }
        }
        .alert(.showsDeleteErrorTitle, isPresented: $showsDeleteError) {
            Button(.okButtonTitle, role: .cancel) {
                print("Error deleting lab result from labResultsRepository")
            }
        } message: {
            Text(.showsDeleteErrorMessage)
        }
        .accessibilityElement(children: .contain)
        if labResults.count > .maxInjectionsToShow {
            Button(action: {
                withAnimation { expanded.toggle() }
            }, label: {
                AccessibleCollapseButton(expanded: $expanded)
            })
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let showMoreButton: Self = "Show more"
    static let noLabResultsHint: Self = "No lab results logged yet"
    static let showsDeleteErrorTitle: Self = "Error deleting lab results"
    static let showsDeleteErrorMessage: Self = "There was an error deleting a lab result from database. Please try again later."
    static let okButtonTitle: Self = "OK"
}

private extension Int {
    static let maxInjectionsToShow: Self = 3
}
