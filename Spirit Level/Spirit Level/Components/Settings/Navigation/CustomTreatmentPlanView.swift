import SwiftUI

struct CustomTreatmentPlanView: View {
    @State private var selectedEster: Ester = .enanthate
    @State private var dose: Double
    @State private var rhythm: Int
    @State private var treatmentPlanName: String = ""
    @State private var showEmptyNameAlert: Bool = false
    @Environment(\.dismiss) private var dismiss

    let buttonAction: (TreatmentPlan) -> Void
    let buttonTitle: LocalizedStringResource
    
    init(addButtonTitle: LocalizedStringResource, action: @escaping (TreatmentPlan) -> Void) {
        let ester = Ester.allCases.first ?? .enanthate
        self.dose = ester.defaultDose
        self.rhythm = ester.defaultRhythm
        self.buttonAction = action
        self.buttonTitle = addButtonTitle
    }
    
    var body: some View {
        List {
            Section(.configurationSectionTitle) {
                HStack {
                    Text(.nameLabel)
                        .padding(.trailing, .nameLabelTrailingPadding)
                    TextField(.enterAliasPlaceholder, text: $treatmentPlanName)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing, .textFieldTrailingPadding)
                }
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("double tap to edit name")

                Picker(.esterLabel, selection: $selectedEster) {
                    ForEach(Ester.allCases) { ester in
                        Text(ester.name).tag(ester)
                    }
                }
                .pickerStyle(.menu)
                .accessibilityElement(children: .combine)

                AccessibleDosagePicker(dosage: $dose)
                AccessibleRythmPicker(rhythm: $rhythm)
            }
            
            Section {
                Button(buttonTitle, action: {
                    guard !treatmentPlanName.isEmpty else {
                        return showEmptyNameAlert.toggle()
                    }
                    self.buttonAction(.init(name: treatmentPlanName,
                                            ester: selectedEster,
                                            frequency: rhythm,
                                            dosage: dose,
                                            firstInjectionDate: .now))
                    dismiss()
                })
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .alert("Empty Name", isPresented: $showEmptyNameAlert) {
            Button("OK", role: .cancel) { showEmptyNameAlert.toggle() }
        } message: {
            Text("The alias field can not be empty")
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let addButtonTitle: Self = "Add"
    static let configurationSectionTitle: Self = "Configuration"
    static let nameLabel: Self = "Name"
    static let enterAliasPlaceholder: Self = "Enter Alias"
    static let esterLabel: Self = "Ester"
}

private extension Double {
    static let doseStep: Self = 0.1
}

private extension CGFloat {
    static let nameLabelTrailingPadding: Self = 8
    static let textFieldTrailingPadding: Self = 2
}
