import SwiftUI
import SwiftData
import HealthDataLogging
import SpiritLevelShared
import OSLog

struct LogLabResultWatchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var concentration: Int = 200
    @State private var date: Date = .now
    @State private var showsSavingErrorAlert: Bool = false

    var body: some View {
        Form {
            Stepper(value: $concentration, in: 0...1000, step: 10) {
                Text("pg/mL: \(concentration)")
                    .font(.footnote)
            }

            DatePickerButton(date: date) { newDate in
                date = newDate
            }

            Button {
                let labResult = LabResult(concentration: Double(concentration),
                                         date: date)
                modelContext.insert(labResult)
                do {
                    try modelContext.save()
                    dismiss()
                } catch {
                    showsSavingErrorAlert.toggle()
                    Logger.data.error("Failed to save lab result: \(error)")
                }
            } label: {
                Text("Log Lab Result")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .listRowBackground(
                Color.accentColor
                    .clipShape(.capsule)
            )
        }
        .alert("Error Saving Data", isPresented: $showsSavingErrorAlert) {
            Button("OK", role: .cancel) { showsSavingErrorAlert.toggle() }
        } message: {
            Text("There was an error saving data. Please try again later.")
        }
        .navigationTitle("Log Lab")
    }
}
