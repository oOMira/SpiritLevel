import SwiftUI
import OSLog

struct LabResultsView<LabResultsRepositoryType: LabResultsManageable>: View {
    @State private var showsDeleteError: Bool = false
    let labResultsRepository: LabResultsRepositoryType
    
    var body: some View {
        let labResults = labResultsRepository.allItems
        List {
            if labResults.isEmpty {
                Text(.noLabResultsHint)
            } else {
                ForEach(labResults) { labResult in
                    Text("\(labResult.concentration.formatted(.number.precision(.fractionLength(0)))) pg on \(labResult.date, format: .dateTime.day().month().year())")
                }
                .onDelete { offsets in
                    offsets.forEach {
                        do {
                            try labResultsRepository.delete(item: labResults[$0])
                        } catch {
                            showsDeleteError.toggle()
                        }
                    }
                }
            }
        }
        .toolbar {
            if !labResultsRepository.allItems.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
            }
        }
        .navigationTitle("Lab Results")
        .alert(.showsDeleteErrorTitle, isPresented: $showsDeleteError) {
            Button(.okButtonTitle, role: .cancel) {
                Logger.data.error("Failed to delete lab result")
            }
        } message: {
            Text(.showsDeleteErrorMessage)
        }
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let noLabResultsHint: Self = "No lab results logged yet"
    static let showsDeleteErrorTitle: Self = "Error deleting lab results"
    static let showsDeleteErrorMessage: Self = "There was an error deleting a lab result from database. Please try again later."
    static let okButtonTitle: Self = "OK"
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        LabResultsView(labResultsRepository: Mocks.labResultsRepository)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        LabResultsView(labResultsRepository: Mocks.labResultsRepository)
    }
    .preferredColorScheme(.dark)
}
