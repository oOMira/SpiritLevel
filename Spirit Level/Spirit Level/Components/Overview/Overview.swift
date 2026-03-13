import SwiftUI

struct Overview<AppStateManagerType: AppStateManageable,
                AppStartRepositoryType: AppStartManageable,
                InjectionRepositoryType: InjectionManageable,
                LabResultsRepositoryType: LabResultsManageable,
                TreatmentPlanRepositoryType: TreatmentPlanManageable,
                HormoneManagerType: HormoneLevelManageable>: View {

    @State private var activeSheet: ShortcutFeature?
    
    let dependencies: AppDependencies<AppStateManagerType,
                                      AppStartRepositoryType,
                                      InjectionRepositoryType,
                                      LabResultsRepositoryType,
                                      TreatmentPlanRepositoryType,
                                      HormoneManagerType>
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            let dependencie = dependencies
            OverviewContentView(viewModel: dependencie)
            .navigationTitle(.navigationTitle)
            // MARK: - Quick Actions
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .logInjection: LogInjectionView(injectionRepository: dependencies.injectionRepository)
                    .presentationDetents([.medium, .large])
                case .logLab: LogLabResultView(labResultsRepository: dependencies.labResultsRepository)
                    .presentationDetents([.medium, .large])
                }
            }

            PhoneQuickActionsView(action: { feature in
                activeSheet = feature
            })
            .accessibilityElement(children: .contain)
            .accessibilityLabel(.accessibilityLabel)
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Overview"
    static let moodTitle: Self = "Mood"
    static let accessibilityLabel: Self = "Quick Actions"
}

struct Reminder: Identifiable, Hashable {
    let id = UUID()
}
