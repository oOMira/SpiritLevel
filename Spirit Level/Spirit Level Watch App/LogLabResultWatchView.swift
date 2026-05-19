import SwiftUI
import SwiftData
import SpiritLevelShared

struct LogLabResultWatchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var concentration: Int = 200

    var body: some View {
        NavigationStack {
            Form {
                Stepper("pg/mL: \(concentration)",
                        value: $concentration, in: 0...10000, step: 10)

                Button("Log Lab Result") {
                    let labResult = LabResult(concentration: Double(concentration),
                                             date: .now)
                    modelContext.insert(labResult)
                    dismiss()
                }
            }
            .navigationTitle("Log Lab")
        }
    }
}
