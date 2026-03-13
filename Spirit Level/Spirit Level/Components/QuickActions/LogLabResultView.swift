import SwiftUI
import OSLog

struct LogLabResultView<LabResultsRepositoryType: LabResultsManageable>: View {
    @Environment(\.dismiss) private var dismiss
    @State private var labResultDate = Date()
    @State private var concentration: String = ""
    @State private var showsSavingErrorAlert: Bool = false
    @State private var showsEmptyConcentrationAlert: Bool = false
    
    let labResultsRepository: LabResultsRepositoryType

    var body: some View {
        NavigationStack {
            List {
                Section {
                    AccessibleNumberPicker(title: .bloodConcentrationTitle,
                                           placeholder: .concentrationPlaceholder,
                                           value: $concentration)
                    AccessibleDatePicker(title: .dateTitle, selectedDate: $labResultDate)
                }
                Section {
                    Button(action: {
                        guard let concentrationValue = Double(concentration) else {
                            return showsEmptyConcentrationAlert.toggle()
                        }

                        do {
                            try labResultsRepository.add(item: .init(concentration: concentrationValue,
                                                                     date: labResultDate))
                        } catch {
                            showsSavingErrorAlert.toggle()
                            Logger.data.error("Failed to save lab result: \(error)")
                        }
                        dismiss()
                    }, label: {
                        Text(.buttonTitle)
                            .frame(maxWidth: .infinity)
                    })
                }
                
            }
            .alert("Invalid Concentration", isPresented: $showsEmptyConcentrationAlert) {
                Button("OK", role: .cancel) { showsEmptyConcentrationAlert.toggle() }
            } message: {
                Text("The concentration can not be empty")
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
    static let buttonTitle: Self = "Log Lab Result"
    static let navigationTitle: Self = "Log Lab Results"
    static let bloodConcentrationTitle: Self = "Blood concentration in pg/ml"
    static let closeLabel: Self = "Close"
    static let concentrationPlaceholder: Self = "Concentration"
    static let dateTitle: Self = "Date"
}

private extension String {
    static let xmarkIcon = "xmark"
}

// MARK: - Previews

#Preview("Light Mode") {
    LogLabResultView(labResultsRepository: Mocks.labResultsRepository)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    LogLabResultView(labResultsRepository: Mocks.labResultsRepository)
        .preferredColorScheme(.dark)
}
