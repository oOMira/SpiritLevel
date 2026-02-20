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
                CustomTreatmentPlanConfigurationView(ester: .enanthate)
            }
            
            Section {
                Button("Add", action: action)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Add Simulation")
    }
}
