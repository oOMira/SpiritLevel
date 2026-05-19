import SwiftUI
import SpiritLevelShared
import OSLog

struct LabResultsView<LabResultsRepo: LabResultsManageable>: View {
    @State private var showsDeleteError: Bool = false
    let labResultsRepository: LabResultsRepo

    var body: some View {
        let labResults = labResultsRepository.allItems
        List {
            if labResults.isEmpty {
                Text(.noLabResultsHint)
            } else {
                ForEach(labResults) { labResult in
                    Text(labResultDescription(for: labResult))
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

private extension LabResultsView {
    func labResultDescription(for labResult: LabResult) -> String {
        let formattedConcentration = labResult.concentration.formatted(
            .number.precision(.fractionLength(0))
        )
        let formattedDate = labResult.date.formatted(.dateTime.day().month().year())
        return "\(formattedConcentration) pg/mL on \(formattedDate)"
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let noLabResultsHint: Self = "No lab results logged yet"
    static let showsDeleteErrorTitle: Self = "Error Deleting Lab Result"
    static let showsDeleteErrorMessage: Self =
        "There was an error deleting a lab result from the database. Please try again later."
    static let okButtonTitle: Self = "OK"
}
