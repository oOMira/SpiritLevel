import SwiftUI
import SwiftData
import HealthDataLogging
import SpiritLevelShared
import OSLog

struct LogInjectionWatchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedEster: Ester = .enanthate
    @State private var dose: Double = 5.0
    @State private var date: Date = .now
    @State private var showsSavingErrorAlert: Bool = false

    var body: some View {
        Form {
            Picker("Ester", selection: $selectedEster) {
                ForEach(Ester.allCases) { ester in
                    Text(ester.name).tag(ester)
                }
            }

            Stepper(value: $dose, in: 0.1...50, step: 0.1) {
                Text("Dose: \(dose, specifier: "%.1f") mg")
                    .font(.footnote)
            }

            DatePickerButton(date: date) { newDate in
                date = newDate
            }

            Button {
                let injection = Injection(ester: selectedEster,
                                          dosage: dose,
                                          date: date.start)
                modelContext.insert(injection)
                do {
                    try modelContext.save()
                    dismiss()
                } catch {
                    showsSavingErrorAlert.toggle()
                    Logger.data.error("Failed to save injection: \(error)")
                }
            } label: {
                Text("Log Injection")
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
        .navigationTitle("Log Injection")
    }
}
