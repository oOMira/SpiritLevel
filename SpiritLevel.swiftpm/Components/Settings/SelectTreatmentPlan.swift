import SwiftUI

struct SelectTreatmentPlan: View {
    @State private var activePlan: Ester = .enanthate
    @State private var selectedDate = Date()
    
    var body: some View {
        List {
            Section(.choosePlanSectionTitle) {
                Picker(selection: $activePlan) {
                    ForEach(Ester.allCases, id: \.self) { ester in
                        Text(ester.name)
                    }
                } label: { EmptyView() }
                .pickerStyle(.inline)
                NavigationLink(.createOwnPlanLink, destination: {
                    List {
                        Section(.configurationSectionTitle) {
                            CustomTreatmentPlanConfigurationView(ester: .enanthate)
                        }
                        Section {
                            Button(action: {
                                print("select")
                            }, label: {
                                Text(.setSelectedButtonTitle)
                                    .frame(maxWidth: .infinity)
                            })
                        }
                    }
                    .navigationTitle(.createOwnPlanNavigationTitle)
                    .navigationBarTitleDisplayMode(.inline)
                })
            }
            Section(.startSectionTitle) {
                DatePicker(.firstInjectionDateLabel,
                           selection: $selectedDate,
                           displayedComponents: .date)
                .accessibilityElement(children: .combine)
                .accessibilityValue(selectedDate.formatted(date: .abbreviated, time: .omitted))
                .accessibilityHint("Double tap to change")

            }
            Section {
                Button(action: {
                    print("set plan")
                }, label: {
                    Text(.setPlanButtonTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                })
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle(.navigationTitle)
    }
}

// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let navigationTitle: Self = "Select Plan"
    static let choosePlanSectionTitle: Self = "Choose Plan"
    static let createOwnPlanLink: Self = "Create own plan"
    static let configurationSectionTitle: Self = "Configuration"
    static let setSelectedButtonTitle: Self = "Set selected"
    static let createOwnPlanNavigationTitle: Self = "Create your own plan"
    static let startSectionTitle: Self = "Start"
    static let firstInjectionDateLabel: Self = "First Injection Date"
    static let setPlanButtonTitle: Self = "Set Plan"
}

// MARK: - Preview

#Preview("Light Mode") {
    NavigationStack {
        SelectTreatmentPlan()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        SelectTreatmentPlan()
    }
    .preferredColorScheme(.dark)
}
