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
                    Text(.enanthateLabel)
                })
            }
            
            Section(.simulationSectionTitle) {
                Picker(.simulationModeLabel, selection: $simulationStyle) {
                    Text(.firstInjectionLabel).tag(0)
                    Text(.stableLabel).tag(1)
                }
                .pickerStyle(.segmented)
                TreatmentPlanCellSimulationView(simulationStyle: $simulationStyle)
                Toggle(.enanthateVisibleToggle, isOn: $eeVisible)
                Toggle(.valerateVisibleToggle, isOn: $eaVisible)
            }
            
            Section(.addSimulationSectionTitle) {
                NavigationLink(destination: {
                    CustomTreatmentPlanView(ester: .enanthate, action: {
                        print("Enanthate Added")
                    })
                }, label: {
                    Text(.addSimulationLabel)
                })
            }
        }
        .navigationTitle(.navigationTitle)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let navigationTitle: Self = "Treatment Plan"
    static let enanthateLabel: Self = "Enanthate"
    static let simulationSectionTitle: Self = "Simulation"
    static let simulationModeLabel: Self = "Simulation Mode"
    static let firstInjectionLabel: Self = "First Injection"
    static let stableLabel: Self = "Stable"
    static let enanthateVisibleToggle: Self = "Enantathe visible"
    static let valerateVisibleToggle: Self = "Valerate visible"
    static let addSimulationSectionTitle: Self = "Add Simulation"
    static let addSimulationLabel: Self = "Add new simulation"
}

// MARK: - Preview

#Preview("Light Mode") {
    NavigationStack {
        TreatmentPlanView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        TreatmentPlanView()
    }
    .preferredColorScheme(.dark)
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
            Section(.configurationSectionTitle) {
                CustomTreatmentPlanConfigurationView(ester: .enanthate)
            }
            
            Section {
                Button(.addButtonTitle, action: action)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle(.addSimulationNavigationTitle)
    }
}
private extension LocalizedStringKey {
    static let configurationSectionTitle: Self = "Configuration"
    static let addButtonTitle: Self = "Add"
    static let addSimulationNavigationTitle: Self = "Add Simulation"
}

