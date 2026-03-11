import SwiftUI

struct LogInjectionView<InjectionRepositoryType: InjectionManageable>: View {
    @Environment(\.dismiss) private var dismiss
    @State private var dose: Double = 5
    @State private var injectionDate: Date = Date()
    @State private var selectedEster: Ester = .enanthate
    @State private var showsSavingErrorAlert: Bool = false
    
    let injectionRepository: InjectionRepositoryType

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
                        // TODO: Add error UI
                        do {
                            try injectionRepository.add(item: .init(ester: selectedEster,
                                                                   dosage: dose,
                                                                   date: injectionDate))
                        } catch {
                            showsSavingErrorAlert.toggle()
                            print(error)
                        }
                        dismiss()
                    }, label: {
                        Text(.buttonTitle)
                            .frame(maxWidth: .infinity)
                    })
                }
                
            }
            
            // TODO: Replace with more sophisticated error UI
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

