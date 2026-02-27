import SwiftUI

struct LogLabResultView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var labResultDate = Date()
    @State private var concentraiton: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    AccessibleNumberPicker(title: .bloodConcentrationTitle,
                                           placeholder: .concentrationPlaceholder,
                                           value: $concentraiton)
                    AccessibleDatePicker(title: .dateTitle, selectedDate: $labResultDate)
                }
                
                Section {
                    Button(action: {
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
