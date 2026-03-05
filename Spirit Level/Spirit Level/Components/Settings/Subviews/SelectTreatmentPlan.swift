import SwiftUI

struct SelectTreatmentPlan<TreatmentRepositoryType: TreatmentPlanManageable>: View {
    @Environment(\.dismiss) private var dismiss
    @State private var predefinedTreatmentPlans: [TreatmentPlan]
    @State private var activePlan: TreatmentPlan
    @State private var selectedDate: Date = .now
    @State private var showsSavingErrorAlert = false
    
    let treatmentRepository: TreatmentRepositoryType
    
    var allTreatmentPlans: [TreatmentPlan] {
        predefinedTreatmentPlans + treatmentRepository.allItems
    }
    
    init(predefinedTreatmentPlans: [TreatmentPlan],
         activePlan: TreatmentPlan,
         treatmentRepository: TreatmentRepositoryType) {
        self.predefinedTreatmentPlans = predefinedTreatmentPlans
        self.activePlan = activePlan
        self.treatmentRepository = treatmentRepository
    }
    
    var body: some View {
        List {
            Section(.choosePlanSectionTitle) {
                Picker(selection: $activePlan) {
                    ForEach(allTreatmentPlans, id: \.self) { plan in
                        Text(plan.name)
                    }
                } label: { EmptyView() }
                .pickerStyle(.inline)
                NavigationLink(.createOwnPlanLink, destination: {
                    CustomTreatmentPlanView(addButtonTitle: "Select", action: { plan in
                        do {
                            try treatmentRepository.add(item: plan)
                        } catch {
                            // TODO: handle error
                            print("error")
                        }
                    })
                    .navigationTitle(.createNewPlanNavigationTitle)
                })
            }
            Section(.startSectionTitle) {
                AccessibleDatePicker(title: .firstInjectionDateLabel,
                                     selectedDate: $selectedDate)

            }
            Section {
                Button(action: {
                    // TODO: also delete plans in the past without injections
                    if let latest = treatmentRepository.latest, latest.firstInjectionDate >= Calendar.current.startOfDay(for: .now) {
                        do {
                            try treatmentRepository.delete(item: latest)
                        } catch {
                            showsSavingErrorAlert.toggle()
                            print(error)
                        }
                    }
                    do {
                        let newPlan: TreatmentPlan = .init(name: activePlan.name,
                                                           ester: activePlan.ester,
                                                           frequency: activePlan.frequency,
                                                           dosage: activePlan.dosage,
                                                           firstInjectionDate: selectedDate)
                        try treatmentRepository.add(item: newPlan)
                        activePlan = newPlan
                    } catch {
                        print(error)
                        showsSavingErrorAlert.toggle()
                    }
                    dismiss()
                }, label: {
                    Text(.setPlanButtonTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                })
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle(.navigationTitle)
        // TODO: Replace with more sophisticated error UI
        .alert("Error Setting Plan", isPresented: $showsSavingErrorAlert) {
            Button("OK", role: .cancel) { showsSavingErrorAlert.toggle() }
        } message: {
            Text("Error setting treatment plan. Please try again later.")
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let createNewPlanNavigationTitle: Self = "Create New Plan"
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
