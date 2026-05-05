import SwiftUI
import OSLog

struct SelectTreatmentPlan<TreatmentPlanRepo: TreatmentPlanManageable>: View {
    @Environment(\.dismiss) private var dismiss
    private let activePlan: TreatmentPlan?
    @State private var currentActivePlan: TreatmentPlan
    @State private var selectedDate: Date = .now
    @State private var showsSavingErrorAlert = false
    @Bindable private var treatmentPlanStore: TreatmentPlanStore

    let treatmentRepository: TreatmentPlanRepo

    var allTreatmentPlans: [TreatmentPlan] {
        treatmentPlanStore.planConfigurations.compactMap(\.plan)
    }

    init(activePlan: TreatmentPlan?,
         treatmentRepository: TreatmentPlanRepo,
         treatmentPlanStore: Bindable<TreatmentPlanStore>) {
        let plans = treatmentPlanStore.wrappedValue.planConfigurations.compactMap(\.plan)
        if let activePlan, let firstPlan = plans.first {
            self.currentActivePlan = plans.contains(activePlan) ? activePlan : firstPlan
        } else {
            self.currentActivePlan = plans.first ?? Ester.enanthate.predefinedStablePlan()
        }
        self.activePlan = activePlan
        self.treatmentRepository = treatmentRepository
        self._treatmentPlanStore = treatmentPlanStore
    }

    var body: some View {
        List {
            if let activePlanName = activePlan?.name {
                Section(.activePlanTitle) {
                    Text(activePlanName)
                }
            }
            Section(.choosePlanSectionTitle) {
                Picker(selection: $currentActivePlan) {
                    ForEach(allTreatmentPlans, id: \.self) { plan in
                        Text(plan.name)
                    }
                } label: { EmptyView() }
                .pickerStyle(.inline)
                NavigationLink(.createOwnPlanLink, destination: {
                    CustomTreatmentPlanView(addButtonTitle: "Select", action: { plan in
                        treatmentPlanStore.planConfigurations.append(
                            .init(plan: plan, visible: true, editable: true)
                        )
                        currentActivePlan = plan
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
                    if let latest = treatmentRepository.getLatest(),
                       latest.firstInjectionDate >= Calendar.current.startOfDay(for: .now) {
                        do {
                            try treatmentRepository.delete(item: latest)
                        } catch {
                            showsSavingErrorAlert.toggle()
                            Logger.data.error("Failed to delete previous treatment plan: \(error)")
                        }
                    }
                    do {
                        let newPlan: TreatmentPlan = .init(name: currentActivePlan.name,
                                                           ester: currentActivePlan.ester,
                                                           frequency: currentActivePlan.frequency,
                                                           dosage: currentActivePlan.dosage,
                                                           firstInjectionDate: selectedDate)
                        try treatmentRepository.add(item: newPlan)
                        currentActivePlan = newPlan
                    } catch {
                        Logger.data.error("Failed to save treatment plan: \(error)")
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
    static let activePlanTitle: Self = "Current Plan"
    static let navigationTitle: Self = "Select Plan"
    static let choosePlanSectionTitle: Self = "Choose Plan"
    static let createOwnPlanLink: Self = "Create your own plan"
    static let configurationSectionTitle: Self = "Configuration"
    static let setSelectedButtonTitle: Self = "Set Selected"
    static let createOwnPlanNavigationTitle: Self = "Create your own plan"
    static let startSectionTitle: Self = "Start"
    static let firstInjectionDateLabel: Self = "First Injection Date"
    static let setPlanButtonTitle: Self = "Set Plan"
}
