import SwiftUI
import OSLog

struct LogInjectionView<InjectionRepo: InjectionManageable>: View {
    @Environment(\.dismiss) private var dismiss
    @State private var dose: Double = 5
    @State private var injectionDate: Date = Date()
    @State private var selectedEster: Ester = .enanthate
    @State private var showsSavingErrorAlert: Bool = false

    let injectionRepository: InjectionRepo

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(.esterLabel, selection: $selectedEster) {
                        ForEach(Ester.allCases) { ester in
                            Text(ester.name).tag(ester)
                        }
                    }
                    .accessibilityElement(children: .combine)

                    AccessibleDosagePicker(dosage: $dose)
                    AccessibleDatePicker(title: "Injection Date", selectedDate: $injectionDate)
                }

                Section {
                    Button(action: {
                        do {
                            try injectionRepository.add(item: .init(ester: selectedEster,
                                                                   dosage: dose,
                                                                   date: injectionDate))
                        } catch {
                            showsSavingErrorAlert.toggle()
                            Logger.data.error("Failed to save injection: \(error)")
                        }
                        dismiss()
                    }, label: {
                        Text(.buttonTitle)
                            .frame(maxWidth: .infinity)
                    })
                }

            }
            .alert("Error Saving Data", isPresented: $showsSavingErrorAlert) {
                Button("OK", role: .cancel) { showsSavingErrorAlert.toggle() }
            } message: {
                Text("There was an error saving data. Please try again later.")
            }

            .navigationTitle(.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label(.closeLabel, systemImage: .xmarkIcon)
                    }
                }
            }
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let buttonTitle: Self = "Log Injection"
    static let navigationTitle: Self = "Log Injection"
    static let closeLabel: Self = "Close"
    static let esterLabel: Self = "Ester"
}

private extension String {
    static let xmarkIcon = "xmark"
}

private extension String {
    static let dosageFormat = "%.1f"
}

// MARK: - Previews

#Preview("Light Mode") {
    LogInjectionView(injectionRepository: Mocks.injectionsRepository)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    LogInjectionView(injectionRepository: Mocks.injectionsRepository)
        .preferredColorScheme(.dark)
}
