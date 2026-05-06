import SwiftUI
import SwiftData
import HealthDataLogging
import SpiritLevelShared
import OSLog

struct LabResultDetailWatchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showsDeleteErrorAlert: Bool = false

    let labResult: LabResult

    var body: some View {
        List {
            LabeledContent("Date") {
                Text(labResult.date, format: .dateTime.day().month().year())
            }

            LabeledContent("Concentration") {
                Text(concentrationDescription)
            }

            Button(role: .destructive) {
                delete()
            } label: {
                Text("Delete")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .alert("Error Deleting Lab Result", isPresented: $showsDeleteErrorAlert) {
            Button("OK", role: .cancel) { showsDeleteErrorAlert.toggle() }
        } message: {
            Text("There was an error deleting the lab result. Please try again later.")
        }
        .navigationTitle("Lab Result")
    }

    private var concentrationDescription: String {
        let formatted = labResult.concentration.formatted(.number.precision(.fractionLength(0)))
        return "\(formatted) pg/mL"
    }

    private func delete() {
        modelContext.delete(labResult)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            showsDeleteErrorAlert.toggle()
            Logger.data.error("Failed to delete lab result: \(error)")
        }
    }
}
