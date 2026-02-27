import SwiftUI

struct LogInjectionView<InjectionRepositoryType: InjectionManagable>: View {
    @Environment(\.dismiss) private var dismiss
    @State private var dose: Double = 5
    @State private var injectionDate: Date = Date()
    @State private var selectedEster: Ester = .enanthate
    
    let injecionRepository: InjectionRepositoryType

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(.esterLabel, selection: $selectedEster) {
                        ForEach(Ester.allCases) { ester in
                            Text(ester.name).tag(ester)
                        }
                    }
                    
                    AccessibleDosagePicker(dosage: $dose)
                    AccessibleDatePicker(title: "Injection Date", selectedDate: $injectionDate)
                }
                
                Section {
                
                    Button(action: {
                        // TODO: Add error UI
                        do {
                            try injecionRepository.add(item: .init(ester: selectedEster,
                                                                   dosage: dose,
                                                                   date: injectionDate))
                        } catch {
                            print(error)
                        }
                        dismiss()
                    }, label: {
                        Text(.buttonTitle)
                            .frame(maxWidth: .infinity)
                    })
                }
                
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
    static let doseageFormat = "%.1f"
}

