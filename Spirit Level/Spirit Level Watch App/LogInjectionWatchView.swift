import SwiftUI
import SwiftData
import HealthDataLogging

struct LogInjectionWatchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedEster: Ester = .enanthate
    @State private var dose: Double = 5.0

    var body: some View {
        NavigationStack {
            Form {
                Picker("Ester", selection: $selectedEster) {
                    ForEach(Ester.allCases) { ester in
                        Text(ester.name).tag(ester)
                    }
                }

                Stepper("Dose: \(dose, specifier: "%.1f") mg",
                        value: $dose, in: 0.1...50, step: 0.1)

                Button("Log Injection") {
                    let injection = Injection(ester: selectedEster,
                                             dosage: dose,
                                             date: .now)
                    modelContext.insert(injection)
                    dismiss()
                }
            }
            .navigationTitle("Log Injection")
        }
    }
}
