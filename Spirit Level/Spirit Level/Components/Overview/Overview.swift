import SwiftUI

struct Overview<AppStateManagerType: AppStateManageable,
                AppStartRepositoryType: AppStartManageable,
                InjectionRepositoryType: InjectionManageable,
                LabResultsRepositoryType: LabResultsManageable,
                TreatmentPlanRepositoryType: TreatmentPlanManageable,
                HormoneManagerType: HormoneLevelManageable>: View {
    @State private var activeSheet: ShortcutFeature?
    var appStateManager: AppStateManagerType
    var appStartRepository: AppStartRepositoryType
    var injectionRepository: InjectionRepositoryType
    var labResultsRepository: LabResultsRepositoryType
    var treatmentPlanRepository: TreatmentPlanRepositoryType
    let hormoneManager: HormoneManagerType
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                OverviewContentView(appStateManager: appStateManager,
                                    appStartManager: appStartRepository,
                                    injectionRepository: injectionRepository,
                                    treatmentPlanRepository: treatmentPlanRepository,
                                    hormoneLevelManager: hormoneManager,
                                    labResultsRepository: labResultsRepository)
            }
            .navigationTitle(.navigationTitle)
            // MARK: - Quick Actions
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .logInjection: LogInjectionView(injectionRepository: injectionRepository)
                    .presentationDetents([.medium, .large])
                case .logLab: LogLabResultView(labResultsRepository: labResultsRepository)
                    .presentationDetents([.medium, .large])
                }
            }

            PhoneQuickActionsView(action: { feature in
                activeSheet = feature
            })
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Quick Actions")
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Overview"
    static let moodTitle: Self = "Mood"
}


