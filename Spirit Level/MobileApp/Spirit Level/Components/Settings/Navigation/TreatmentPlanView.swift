import SwiftUI
import HealthDataLogging
import SpiritLevelShared
import OSLog

typealias TreatmentPlanDependencies =
    HasTreatmentPlanRepository &
    HasTreatmentPlanConfigurationRepository &
    HasHormoneLevelManager

struct TreatmentPlanView<Dependencies: TreatmentPlanDependencies>: View {
    private let historyAnimation = "historyAnimation"

    @Namespace var animationNamespace
    @State private var simulationStyle: SimulationStyle = .stable
    @State private var showsTreatmentPlanHistory: Bool = false
    @State private var showsCustomTreatmentPlan: Bool = false
    @State private var showsAddErrorAlert: Bool = false

    let dependencies: Dependencies

    var activeTreatmentPlan: TreatmentPlan? { dependencies.treatmentPlanRepository.getLatest() }
    var allTreatmentConfigurations: [TreatmentPlanConfiguration] {
        dependencies.treatmentPlanConfigurationRepository.allItems
            .sorted { lhs, rhs in
                if lhs.editable != rhs.editable {
                    return !lhs.editable
                }
                return lhs.name < rhs.name
            }
    }

    var body: some View {
        List {
            Section {
                NavigationLink(destination: {
                    SelectTreatmentPlan(activePlan: activeTreatmentPlan,
                                        treatmentRepository: dependencies.treatmentPlanRepository,
                                        configurationRepository: dependencies.treatmentPlanConfigurationRepository)
                }, label: {
                    if let activeTreatmentPlan {
                        Text(activeTreatmentPlan.name)
                            .accessibilityHint("Active treatment plan. Double-tap to select a different one.")
                    } else {
                        Text(.noActiveTreatmentPlan)
                            .accessibilityHint("Double-tap to select a treatment plan.")
                    }
                })
            }

            Section(content: {
                Picker(.simulationModeLabel, selection: $simulationStyle) {
                    ForEach(SimulationStyle.allCases) {
                        Text($0.label).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                TreatmentPlanCellSimulationView(hormoneManager: dependencies.hormoneLevelManager,
                                                treatmentConfigurations: allTreatmentConfigurations,
                                                simulationStyle: simulationStyle)
                ForEach(allTreatmentConfigurations) { configuration in
                    let deleteAction = configuration.editable
                        ? { delete(configuration: configuration) }
                        : nil
                    ConfigurationCellView(configuration: configuration,
                                          deleteAction: deleteAction)
                }
            }, header: {
                Text("Estimated E2 in pg/mL")
            }, footer: {
                Text(.medicalDisclaimer)
            })

            Button(action: {
                showsCustomTreatmentPlan.toggle()
            }, label: {
                Text(.addSimulationLabel)
                    .frame(maxWidth: .infinity, alignment: .center)
            })
        }
        .refreshable {
            dependencies.treatmentPlanRepository.refresh()
            dependencies.treatmentPlanConfigurationRepository.refresh()
        }
        .navigationTitle(.navigationTitle)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button("History", systemImage: "clock", action: {
                    showsTreatmentPlanHistory.toggle()
                })
                .matchedTransitionSource(id: historyAnimation, in: animationNamespace)
                .tint(.primary)
                .contentShape(.circle)
                .contentShape(.accessibility, RoundedRectangle(cornerRadius: 2).inset(by: -4))
            })
        }
        .sheet(isPresented: $showsTreatmentPlanHistory, content: {
            TreatmentPlanHistory(treatmentPlanRepository: dependencies.treatmentPlanRepository)
                .navigationTransition(.zoom(sourceID: historyAnimation, in: animationNamespace))
        })
        .sheet(isPresented: $showsCustomTreatmentPlan, content: {
            NavigationStack {
                CustomTreatmentPlanView(addButtonTitle: "Add", action: { plan in
                    let configuration = TreatmentPlanConfiguration(name: plan.name,
                                                                   ester: plan.ester,
                                                                   frequency: plan.frequency,
                                                                   dosage: plan.dosage,
                                                                   visible: true,
                                                                   editable: true)
                    do {
                        Logger.app.info("Adding new treatment plan configuration: \(configuration.name)")
                        try dependencies.treatmentPlanConfigurationRepository.add(item: configuration)
                    } catch {
                        Logger.data.error("Failed to add treatment plan configuration: \(error)")
                        showsAddErrorAlert = true
                    }
                })
                .navigationTitle(.addNewSimulationNavigationBar)
            }
        })
        .alert(Text(.addErrorTitle), isPresented: $showsAddErrorAlert) {
            Button("OK", role: .cancel) { showsAddErrorAlert = false }
        } message: {
            Text(.addErrorMessage)
        }
    }
}

// MARK: - Helper

extension TreatmentPlanView {
    private func delete(configuration: TreatmentPlanConfiguration) {
        Logger.data.info("Deleting treatment plan configuration: \(configuration.name)")
        withAnimation {
            do {
                try dependencies.treatmentPlanConfigurationRepository.delete(item: configuration)
            } catch {
                Logger.data.error("Failed to delete treatment plan configuration: \(error)")
            }
        }
    }
}

enum SimulationStyle: String, Identifiable, Hashable, CaseIterable {
    var id: String { rawValue }

    case firstInjection
    case stable

    var label: LocalizedStringResource {
        switch self {
        case .firstInjection: .firstInjectionLabel
        case .stable: .stableLabel
        }
    }
}

private extension TreatmentPlanView {
    struct ConfigurationCellView: View {
        @Bindable var configuration: TreatmentPlanConfiguration
        let deleteAction: (() -> Void)?

        init(configuration: TreatmentPlanConfiguration, deleteAction: (() -> Void)? = nil) {
            self.configuration = configuration
            self.deleteAction = deleteAction
        }

        var body: some View {
            HStack {
                if let deleteAction {
                    Button(action: {
                        deleteAction()
                    }, label: {
                        SystemImage.xCircle.image
                    })
                    .buttonStyle(.borderless)
                }
                Toggle(configuration.name, isOn: $configuration.visible)
            }
        }
    }

}

// MARK: - Constants

private extension LocalizedStringResource {
    static let addNewSimulationNavigationBar: Self = "Add New Simulation"
    static let noActiveTreatmentPlan: Self = "No active treatment plan"
    static let navigationTitle: Self = "Treatment Plan"
    static let simulationSectionTitle: Self = "Simulation"
    static let simulationModeLabel: Self = "Simulation Mode"
    static let firstInjectionLabel: Self = "First Injection"
    static let stableLabel: Self = "Stable"
    static let enanthateVisibleToggle: Self = "Enanthate visible"
    static let valerateVisibleToggle: Self = "Valerate visible"
    static let addSimulationSectionTitle: Self = "Add Simulation"
    static let addSimulationLabel: Self = "Add New Simulation"
    static let medicalDisclaimer: Self = "This is not medical advice, but a rough estimate."
    static let addErrorTitle: Self = "Couldn't Add Simulation"
    static let addErrorMessage: Self = "Something went wrong while adding the simulation. Please try again later."
}
