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
        Picker(.esterLabel, selection: $selectedEster) {
            ForEach(Ester.allCases) { ester in
                Text(ester.name).tag(ester)
            }
        }
        Stepper(label: {
            Text("Doseage: \(dose, specifier: .doseageFormat) mg")
        }, onIncrement: {
            dose += .doseStep
        }, onDecrement: {
            dose -= .doseStep
        })
        Stepper("Repeat every \(rythm) days", value: $rythm, in: .rythmRange)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let nameLabel: Self = "Name"
    static let enterAliasPlaceholder: Self = "Enter Alias"
    static let esterLabel: Self = "Ester"
}

private extension String {
    static let doseageFormat = "%.1f"
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

// MARK: - Preview

#Preview("Light Mode") {
    List {
        CustomTreatmentPlanConfigurationView(ester: .enanthate)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    List {
        CustomTreatmentPlanConfigurationView(ester: .enanthate)
    }
    .preferredColorScheme(.dark)
}
