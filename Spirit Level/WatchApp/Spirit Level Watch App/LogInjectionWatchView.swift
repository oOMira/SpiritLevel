import SwiftUI
import SwiftData
import SpiritLevelShared

struct LogInjectionWatchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedEster: Ester = .enanthate
    @State private var dose: Double = 5.0
    @State private var datePickerDate: Date = .now
    @State private var date: Date = .now
    @State private var isDatePickerPresented = false

    var body: some View {
        NavigationStack {
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
                    let injection = Injection(ester: selectedEster,
                                              dosage: dose,
                                              date: date.start)
                    modelContext.insert(injection)
                    dismiss()
                } label: {
                    Text("Log Injection")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(
                    Color.accentColor
                        .clipShape(.capsule)
                )
            }
            .navigationTitle("Log Injection")
            .sheet(isPresented: $isDatePickerPresented) {
                NavigationStack {
                    DatePicker("Date",
                               selection: $datePickerDate,
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
