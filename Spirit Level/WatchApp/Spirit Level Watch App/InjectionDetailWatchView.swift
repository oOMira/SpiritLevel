import SwiftUI
import SwiftData
import HealthDataLogging
import SpiritLevelShared
import OSLog

struct InjectionDetailWatchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showsDeleteErrorAlert: Bool = false

    let injection: Injection

    var body: some View {
        List {
            LabeledContent("Date") {
                Text(injection.date, format: .dateTime.day().month().year())
            }

            LabeledContent("Ester") {
                Text(injection.ester.name)
            }

            LabeledContent("Dose") {
                Text(doseDescription)
            }

            Button(role: .destructive) {
                delete()
            } label: {
                Text("Delete")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .alert("Error Deleting Injection", isPresented: $showsDeleteErrorAlert) {
            Button("OK", role: .cancel) { showsDeleteErrorAlert.toggle() }
        } message: {
            Text("There was an error deleting the injection. Please try again later.")
        }
        .navigationTitle("Injection")
    }

    private var doseDescription: String {
        let formatted = String(format: "%.1f", injection.dosage)
        return "\(formatted) mg"
    }

    private func delete() {
        modelContext.delete(injection)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            showsDeleteErrorAlert.toggle()
            Logger.data.error("Failed to delete injection: \(error)")
        }
    }
}
