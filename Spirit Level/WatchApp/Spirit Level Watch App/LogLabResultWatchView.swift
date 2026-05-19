import SwiftUI
import SwiftData
import SpiritLevelShared

struct LogLabResultWatchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var concentration: Int = 200
    @State private var datePickerDate: Date = .now
    @State private var date: Date = .now
    @State private var isDatePickerPresented = false

    var body: some View {
        NavigationStack {
            Form {
                Stepper(value: $concentration, in: 0...1000, step: 10) {
                    Text("pg/mL: \(concentration)")
                        .font(.footnote)
                }

                Button {
                    isDatePickerPresented = true
                } label: {
                    HStack {
                        Text("Date")
                        Text(date, format: .dateTime.day().month().year())
                            .foregroundStyle(.tint)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }

                Button {
                    let labResult = LabResult(concentration: Double(concentration),
                                             date: date)
                    modelContext.insert(labResult)
                    dismiss()
                } label: {
                    Text("Log Lab Result")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(
                    Color.accentColor
                        .clipShape(.capsule)
                )
            }
            .navigationTitle("Log Lab")
            .sheet(isPresented: $isDatePickerPresented) {
                NavigationStack {
                    DatePicker("Date",
                               selection: $date,
                               displayedComponents: [.date])
                        .navigationTitle("Date")
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    date = datePickerDate
                                    isDatePickerPresented = false
                                }
                            }
                        }
                }
                .onDisappear { datePickerDate = date }
            }
        }
    }
}
