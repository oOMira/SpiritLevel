import SwiftUI
import HealthDataLogging
import SpiritLevelShared
import OSLog

struct SelectTreatmentPlan<TreatmentPlanRepo: TreatmentPlanManageable,
                           ConfigurationRepo: TreatmentPlanConfigurationManageable>: View {
    @Environment(\.dismiss) private var dismiss
    private let activePlan: TreatmentPlan?
    @State private var currentActiveConfigurationID: UUID?
    @State private var selectedDate: Date = .now
    @State private var showsSavingErrorAlert = false
    @State private var showsCustomTreatmentPlanSheet = false

    let treatmentRepository: TreatmentPlanRepo
    let configurationRepository: ConfigurationRepo

    init(activePlan: TreatmentPlan?,
         treatmentRepository: TreatmentPlanRepo,
         configurationRepository: ConfigurationRepo) {
        self.activePlan = activePlan
        self.treatmentRepository = treatmentRepository
        self.configurationRepository = configurationRepository

        let configurations = configurationRepository.allItems
        let matchedID = activePlan.flatMap { plan in
            configurations.first(where: { $0.matches(plan) })?.id
        }
        self._currentActiveConfigurationID = State(initialValue: matchedID ?? configurations.first?.id)
    }

    var body: some View {
        List {
            if let activePlanName = activePlan?.name {
                Section(.activePlanTitle) {
                    Text(activePlanName)
                }
            }
            Section(.choosePlanSectionTitle) {
                Picker(selection: $currentActiveConfigurationID) {
                    ForEach(configurationRepository.allItems) { configuration in
                        Text(configuration.name).tag(Optional(configuration.id))
                    }
                } label: { EmptyView() }
                .pickerStyle(.inline)
                Button(action: {
                    showsCustomTreatmentPlanSheet.toggle()
                }, label: {
                    HStack {
                        Text(.createNewPlanButtonTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        SystemImage.plus.image
                    }
                })
                .buttonStyle(.borderless)
            }
            Section(.startSectionTitle) {
                AccessibleDatePicker(title: .firstInjectionDateLabel,
                                     selectedDate: $selectedDate)

            }
            Section {
                Button(action: setPlan, label: {
                    Text(.setPlanButtonTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                })
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(currentActiveConfigurationID == nil)
            }
        }
        .refreshable {
            treatmentRepository.refresh()
            configurationRepository.refresh()
        }
        .navigationTitle(.navigationTitle)
        .alert("Error Setting Plan", isPresented: $showsSavingErrorAlert) {
            Button("OK", role: .cancel) { showsSavingErrorAlert.toggle() }
        } message: {
            Text("Error setting treatment plan. Please try again later.")
        }
        .sheet(isPresented: $showsCustomTreatmentPlanSheet) {
            NavigationStack {
                CustomTreatmentPlanView(addButtonTitle: "Select", action: { plan in
                    let configuration = TreatmentPlanConfiguration(name: plan.name,
                                                                   ester: plan.ester,
                                                                   frequency: plan.frequency,
                                                                   dosage: plan.dosage,
                                                                   visible: true,
                                                                   editable: true)
                    do {
                        try configurationRepository.add(item: configuration)
                        currentActiveConfigurationID = configuration.id
                    } catch {
                        Logger.data.error("Failed to add treatment plan configuration: \(error)")
                    }
                })
                .navigationTitle(.createNewPlanNavigationTitle)
            }
        }
    }

    private func setPlan() {
        guard let configurationID = currentActiveConfigurationID,
              let selectedConfiguration = configurationRepository.allItems.first(where: {
                  $0.id == configurationID
              }) else { return }

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
            let newPlan = TreatmentPlan(name: selectedConfiguration.name,
                                        ester: selectedConfiguration.ester,
                                        frequency: selectedConfiguration.frequency,
                                        dosage: selectedConfiguration.dosage,
                                        firstInjectionDate: selectedDate)
            try treatmentRepository.add(item: newPlan)
        } catch {
            Logger.data.error("Failed to save treatment plan: \(error)")
            showsSavingErrorAlert.toggle()
        }
        dismiss()
    }
}

private extension TreatmentPlanConfiguration {
    func matches(_ plan: TreatmentPlan) -> Bool {
        name == plan.name &&
        ester == plan.ester &&
        frequency == plan.frequency &&
        dosage == plan.dosage
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let createNewPlanNavigationTitle: Self = "Create New Plan"
    static let activePlanTitle: Self = "Current Plan"
    static let navigationTitle: Self = "Select Plan"
    static let choosePlanSectionTitle: Self = "Choose Plan"
    static let createNewPlanButtonTitle: Self = "Create new plan"
    static let configurationSectionTitle: Self = "Configuration"
    static let setSelectedButtonTitle: Self = "Set Selected"
    static let startSectionTitle: Self = "Start"
    static let firstInjectionDateLabel: Self = "First Injection Date"
    static let setPlanButtonTitle: Self = "Set Plan"
}
