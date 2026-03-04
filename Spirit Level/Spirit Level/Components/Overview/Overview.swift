import SwiftUI

struct Overview<AppStateManagerType: AppStateManageable,
                AppStartRepositoryType: AppStartManageable,
                InjectionRepositoryType: InjectionManageable,
                LabResultsRepositoryType: LabResultsManageable,
                TreatmentPlanRepositoryType: TreatmentPlanManageable,
                HormoneManagerType: HormoneLevelManageable>: View {

    @State private var activeSheet: ShortcutFeature?

    private let appStateManager: AppStateManagerType
    private let appStartRepository: AppStartRepositoryType
    private let injectionRepository: InjectionRepositoryType
    private let labResultsRepository: LabResultsRepositoryType
    private let treatmentPlanRepository: TreatmentPlanRepositoryType
    private let hormoneManager: HormoneManagerType
    
    init(appStateManager: AppStateManagerType,
         appStartRepository: AppStartRepositoryType,
         injectionRepository: InjectionRepositoryType,
         labResultsRepository: LabResultsRepositoryType,
         treatmentPlanRepository: TreatmentPlanRepositoryType,
         hormoneManager: HormoneManagerType) {
        self.appStateManager = appStateManager
        self.appStartRepository = appStartRepository
        self.injectionRepository = injectionRepository
        self.labResultsRepository = labResultsRepository
        self.treatmentPlanRepository = treatmentPlanRepository
        self.hormoneManager = hormoneManager
    }
    
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


struct SetupCellView: View {
    let title: LocalizedStringResource
    let setupAction: () -> Void
    let dismissAction: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: setupAction, label: {
                Text("setup")
            })
            Button(action: dismissAction, label: {
                Text("dismiss")
            })
        }
    }
}
