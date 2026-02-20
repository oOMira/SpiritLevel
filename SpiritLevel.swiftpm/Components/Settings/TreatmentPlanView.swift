import SwiftUI

struct TreatmentPlanView: View {
    @State private var simulationStyle: Int = 1
    @State private var eeVisible: Bool = true
    @State private var eaVisible: Bool = true
    
    var body: some View {
        List {
            Section {
                NavigationLink(destination: {
                    SelectTreatmentPlan()
                }, label: {
                    Text("Enanthate")
                })
            }
            
            Section("Simulation") {
                Picker("Simulation Mode", selection: $simulationStyle) {
                    Text("First Injection").tag(0)
                    Text("Stable").tag(1)
                }
                .pickerStyle(.segmented)
                StatisticsCellView()
                Toggle("Enantathe visible", isOn: $eeVisible)
                Toggle("Valerate visible", isOn: $eaVisible)
            }
            
            Section("Add Simulation") {
                NavigationLink(destination: {
                    CustomTreatmentPlanView(ester: .enanthate, action: {
                        print("Enanthate Added")
                    })
                }, label: {
                    Text("Add new simulation")
                })
            }
        }
        .navigationTitle("Treatment Plan")
    }
}


private struct CustomTreatmentPlanView: View {
    @State private var selectedEster: Ester = .enanthate
    @State private var dose: Double
    @State private var rythm: Int
    @State private var treatmentPlanName: String = ""

    let ester: Ester
    let action: () -> Void
    
    init(ester: Ester, action: @escaping () -> Void) {
        self.dose = ester.defaultDose
        self.rythm = ester.defaultRythm
        self.ester = ester
        self.action = action
    }
    
    var body: some View  {
        List {
            Section("Configuration") {
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
            
            Section {
                Button("Add", action: action)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Add Simulation")
    }
}


private extension Ester {
    var defaultDose: Double {
        switch self {
        case .enanthate: 5
        case .valerate: 5
        }
    }
    
    var defaultRythm: Int {
        switch self {
        case .enanthate: 10
        case .valerate: 7
        }
    }
}
