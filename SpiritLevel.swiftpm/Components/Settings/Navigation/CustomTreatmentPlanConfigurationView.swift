import SwiftUI

struct CustomTreatmentPlanConfigurationView: View {
    @State private var selectedEster: Ester = .enanthate
    @State private var dose: Double
    @State private var rythm: Int
    @State private var treatmentPlanName: String = ""

    let ester: Ester
    
    init(ester: Ester) {
        self.dose = ester.defaultDose
        self.rythm = ester.defaultRythm
        self.ester = ester
    }
    
    var body: some View  {
        HStack {
            Text(.nameLabel)
                .padding(.trailing, .nameLabelTrailingPadding)
            TextField(.enterAliasPlaceholder, text: $treatmentPlanName)
                .multilineTextAlignment(.trailing)
                .padding(.trailing, .textFieldTrailingPadding)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("double tab to edit name")

        Picker(.esterLabel, selection: $selectedEster) {
            ForEach(Ester.allCases) { ester in
                Text(ester.name).tag(ester)
            }
        }
        AccessibleDosagePicker(dosage: $dose)
        Stepper("Repeat every \(rythm) days", value: $rythm, in: .rythmRange)
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let nameLabel: Self = "Name"
    static let enterAliasPlaceholder: Self = "Enter Alias"
    static let esterLabel: Self = "Ester"
}

private extension Double {
    static let doseStep: Self = 0.1
}

private extension ClosedRange where Bound == Int {
    static let rythmRange: Self = 0...31
}

private extension CGFloat {
    static let nameLabelTrailingPadding: Self = 8
    static let textFieldTrailingPadding: Self = 2
}
