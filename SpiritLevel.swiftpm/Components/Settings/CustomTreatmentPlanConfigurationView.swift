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
            Text("Name")
                .padding(.trailing, 8)
            TextField("Enter Alias", text: $treatmentPlanName)
                .multilineTextAlignment(.trailing)
                .padding(.trailing, 2)
        }
        Picker("Ester", selection: $selectedEster) {
            ForEach(Ester.allCases) { ester in
                Text(ester.name).tag(ester)
            }
        }
        Stepper(label: {
            Text("Doseage: \(dose, specifier: "%.1f") mg")
        }, onIncrement: {
            dose += 0.1
        }, onDecrement: {
            dose -= 0.1
        })
        Stepper("Repeat every \(rythm) days", value: $rythm, in: 0...31)
    }
}
