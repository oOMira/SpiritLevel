import SwiftUI

@Observable
class TreatmentPlanStore {
    static let shared = TreatmentPlanStore()
    var planConfigurations: [TreatmentPlanConfiguration] = {
        Ester.allCases.map {
            let plan = $0.predefinedStablePlan()
            return .init(plan: plan, visible: true)
        }
    }()
}

struct TreatmentPlanConfiguration: Hashable {
    let plan: TreatmentPlan
    var visible: Bool
}

struct TreatmentPlanView<TreatmentPlanRepositoryType: TreatmentPlanManageable,
                         HormoneLevelManagerType: HormoneLevelManageable>: View {
    private let historyAnimation = "historyAnimation"

    @Namespace var animationNamespace
    @State private var simulationStyle: SimulationStyle = .stable
    @State private var showsTreatmentPlanHistory: Bool = false
    
    let treatmentPlanRepository: TreatmentPlanRepositoryType
    let hormoneLevelManager: HormoneLevelManagerType
    
    @Bindable private var store: TreatmentPlanStore
    var activeTreatmentPlan: TreatmentPlan? { treatmentPlanRepository.latest }
    
    init(treatmentPlanRepository: TreatmentPlanRepositoryType, hormoneLevelManager: HormoneLevelManagerType, store: TreatmentPlanStore = .shared) {
        self.treatmentPlanRepository = treatmentPlanRepository
        self.hormoneLevelManager = hormoneLevelManager
        self.store = store
    }
    
    var body: some View {
        List {
            Section {
                NavigationLink(destination: {
                    SelectTreatmentPlan(activePlan: activeTreatmentPlan,
                                        treatmentRepository: treatmentPlanRepository,
                                        treatmentPlanStore: $store)
                }, label: {
                    if let activeTreatmentPlan {
                        Text(activeTreatmentPlan.name)
                            .accessibilityHint("active treatment plan, double tap to select a different one")
                    } else {
                        Text(.noActiveTreatmentPlan)
                            .accessibilityHint("double tap to select a treatment plan")
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
                TreatmentPlanCellSimulationView(hormoneManager: hormoneLevelManager,
                                                store: store,
                                                simulationStyle: simulationStyle)
                ForEach(store.planConfigurations.enumerated(), id: \.element) { index, element in
                    Toggle(element.plan.name, isOn: $store.planConfigurations[index].visible)
                }
            }, header: {
                EmptyView()
            }, footer: {
                Text(.medicalDisclaimer)
            })
            
            Section(.addSimulationSectionTitle) {
                NavigationLink(destination: {
                    CustomTreatmentPlanView(addButtonTitle: "Add", action: { plan in
                        store.planConfigurations.append(.init(plan: plan, visible: true))
                    })
                    .navigationTitle(.addNewSimulationNavigationBar)
                }, label: {
                    Text(.addSimulationLabel)
                })
            }
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
            TreatmentPlanHistory(treatmentPlanRepository: treatmentPlanRepository)
                .navigationTransition(.zoom(sourceID: historyAnimation, in: animationNamespace))
        })
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

private extension Array where Element == TreatmentPlanConfiguration {
    var plans: [TreatmentPlan] { self.map(\.plan) }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let addNewSimulationNavigationBar: Self = "Add new simulation"
    static let noActiveTreatmentPlan: Self = "No active treatment plan"
    static let navigationTitle: Self = "Treatment Plan"
    static let simulationSectionTitle: Self = "Simulation"
    static let simulationModeLabel: Self = "Simulation Mode"
    static let firstInjectionLabel: Self = "First Injection"
    static let stableLabel: Self = "Stable"
    static let enanthateVisibleToggle: Self = "Enanthate visible"
    static let valerateVisibleToggle: Self = "Valerate visible"
    static let addSimulationSectionTitle: Self = "Add Simulation"
    static let addSimulationLabel: Self = "Add new simulation"
    static let medicalDisclaimer: Self = "This is no medical advice but a rough estimation"
}
