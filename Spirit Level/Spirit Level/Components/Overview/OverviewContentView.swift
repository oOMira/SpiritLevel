import SwiftUI

struct OverviewContentView<AppStateManagerType: AppStateManageable,
                           AppStartManagerType: AppStartManageable,
                           InjectionRepositoryType: InjectionManageable,
                           TreatmentPlanRepositoryType: TreatmentPlanManageable,
                           LabResultsRepositoryType: LabResultsManageable,
                           HormoneLevelManagerType: HormoneLevelManageable>: View {
    
    @Bindable private var appStateManager: AppStateManagerType
    private let injectionRepository: InjectionRepositoryType
    private let treatmentPlanRepository: TreatmentPlanRepositoryType
    private let hormoneLevelManager: HormoneLevelManagerType
    private let appStartManager: AppStartManagerType
    private let labResultsRepository: LabResultsRepositoryType
    private let achievementsManager: AchievementsManager<InjectionRepositoryType,
                                                         TreatmentPlanRepositoryType,
                                                         LabResultsRepositoryType,
                                                         AppStartManagerType>
    
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
    
    var body: some View {
        ForEach(OverviewFeature.allCases) { feature in
            switch feature {
            case .reminders:
                Section("Reminders", content: {
                    SetupCellView(title: "Setup Plan", setupAction: {
                        print("setup")
                    }, dismissAction: {
                        print("dismiss")
                    })
                    SetupCellView(title: "Setup Plan", setupAction: {
                        print("setup")
                    }, dismissAction: {
                        print("dismiss")
                    })
                })
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
                    AchievementsHeader(title: feature.label, destination: {
                        AchievementsView(achievementsManager: achievementsManager)
                    })
                }
            }
        }
    }
}

// MARK: OverviewContentView+AchievementsHeader

private extension OverviewContentView {
    struct AchievementsHeader<Destination: View>: View {
        private let title: String
        private let destination: Destination
        
        init(title: String, @ViewBuilder destination: () -> Destination) {
            self.title = title
            self.destination = destination()
        }
        
        var body: some View {
            NavigationLink(destination: destination, label: {
                HStack {
                    Text(title)
                    SystemImage.chevronForward.image
                        .font(.caption.weight(.semibold))
                }
            })
            .buttonStyle(.plain)
            .accessibilityHint(.accessibilityHint)
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let moodTitle: Self = "Mood"
    static let medicalDisclaimer: Self = "This is no medical advice but a rough estimation"
    static let accessibilityHint: Self = "Double tap for details"
}
