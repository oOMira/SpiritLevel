import SwiftUI

struct OverviewContentView<AppStateManagerType: AppStateManageable,
                           AppStartManagerType: AppStartManageable,
                           InjectionRepositoryType: InjectionManageable,
                           TreatmentPlanRepositoryType: TreatmentPlanManageable,
                           LabResultsRepositoryType: LabResultsManageable,
                           HormoneLevelManagerType: HormoneLevelManageable>: View {
    let now: Date = .now
    
    @Bindable var appStateManager: AppStateManagerType
    let injectionRepository: InjectionRepositoryType
    let treatmentPlanRepository: TreatmentPlanRepositoryType
    let hormoneLevelManager: HormoneLevelManagerType
    let appStartManager: AppStartManagerType
    let labResultsRepository: LabResultsRepositoryType
    let achievementsManager: AchievementsManager<InjectionRepositoryType, TreatmentPlanRepositoryType, LabResultsRepositoryType, AppStartManagerType>
    
    init(appStateManager: AppStateManagerType,
         appStartManager: AppStartManagerType,
         injectionRepository: InjectionRepositoryType,
         treatmentPlanRepository: TreatmentPlanRepositoryType,
         hormoneLevelManager: HormoneLevelManagerType,
         labResultsRepository: LabResultsRepositoryType) {
        self.appStateManager = appStateManager
        self.injectionRepository = injectionRepository
        self.treatmentPlanRepository = treatmentPlanRepository
        self.hormoneLevelManager = hormoneLevelManager
        self.appStartManager = appStartManager
        self.labResultsRepository = labResultsRepository
        self.achievementsManager = AchievementsManager(injectionRepository: injectionRepository,
                                                    treatmentPlanRepository: treatmentPlanRepository,
                                                    labResultsRepository: labResultsRepository,
                                                    appStartRepository: appStartManager)
    }
    
    @ViewBuilder
    var body: some View {
        ForEach(OverviewFeature.allCases, id: \.self) { feature in
            switch feature {
            case .mood:
                Section {
                    if appStateManager.isMoodExpanded {
                        MoodCellView(injectionRepository: injectionRepository,
                                     hormoneManager: hormoneLevelManager)
                    }
                } header: {
                    ExpandableSectionHeader(title: .moodTitle,
                                            expanded: $appStateManager.isMoodExpanded)
                }
            case .currentLevel:
                Section(content: {
                    CurrentHormoneLevelCellView(injectionRepository: injectionRepository,
                                               hormoneManager: hormoneLevelManager)
                }, header: {
                    Text(feature.label)
                }, footer: {
                    if !injectionRepository.allItems.isEmpty {
                        Text(.medicalDisclaimer)
                            .font(.footnote)
                    }
                })
            case .nextInjection:
                Section(feature.label) {
                    NextInjectionCellView(treatmentRepository: treatmentPlanRepository,
                                          injectionRepository: injectionRepository)
                }
            case .achievements:
                Section {
                    AchievementsCellView(achievementManager: achievementsManager)
                        .accessibilityElement(children: .contain)
                } header: {
                    NavigationLink(destination: {
                        AchievementsView(achievementsManager: achievementsManager)
                    }, label: {
                        HStack {
                            Text(feature.label)
                            Image(systemName: "chevron.forward")
                                .font(.caption.weight(.semibold))
                        }
                    })
                    .buttonStyle(.plain)
                    .accessibilityHint("Double tap for details")
                }
            }
        }
    }
}

private extension LocalizedStringResource {
    static let moodTitle: Self = "Mood"
    static let medicalDisclaimer: Self = "This is no medical advice but a rough estimation"
}
