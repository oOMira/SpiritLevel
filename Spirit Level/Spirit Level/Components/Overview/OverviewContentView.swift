import SwiftUI


protocol OverviewContentViewDependencies: AnyObject, Observable {
    associatedtype AppStateManagerType: AppStateManageable
    associatedtype AppStartManagerType: AppStartManageable
    associatedtype InjectionRepositoryType: InjectionManageable
    associatedtype TreatmentPlanRepositoryType: TreatmentPlanManageable
    associatedtype LabResultsRepositoryType: LabResultsManageable
    associatedtype HormoneLevelManagerType: HormoneLevelManageable
    
    var appStateManager: AppStateManagerType { get set }
    var appStartManger: AppStartManagerType { get set }
    var injectionRepository: InjectionRepositoryType { get set }
    var treatmentPlanRepository: TreatmentPlanRepositoryType { get set }
    var hormoneLevelManager: HormoneLevelManagerType { get set }
    var labResultsRepository: LabResultsRepositoryType { get set }
}

struct OverviewContentViewModel<DependencyType: OverviewContentViewDependencies> {
    let dependencies: DependencyType
}

struct OverviewContentView<ViewModel: OverviewContentViewDependencies>: View {
    
    @Bindable var viewModel: ViewModel
    
    @Namespace var animationNamespace
    
    @State private var showsSetupPlanCell: Bool = true
    @State private var showsSetupPlanSheet: Bool = false
    
    
    private let achievementsManager: AchievementsManager<ViewModel.InjectionRepositoryType,
                                                         ViewModel.TreatmentPlanRepositoryType,
                                                         ViewModel.LabResultsRepositoryType,
                                                         ViewModel.AppStartManagerType>
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.achievementsManager = .init(injectionRepository: viewModel.injectionRepository,
                                         treatmentPlanRepository: viewModel.treatmentPlanRepository,
                                         labResultsRepository: viewModel.labResultsRepository,
                                         appStartRepository: viewModel.appStartManger)
    }
    
    var body: some View {
        List(OverviewFeature.allCases) { feature in
            switch feature {
            case .reminders:
                if [showsSetupPlanCell].contains(true) {
                    Section("Reminders", content: {
                        if showsSetupPlanCell {
                            SetupCellView(systemImage: .chevronForward,
                                          title: "Setup Plan",
                                          setupAction: {
                                print("setup")
                                showsSetupPlanSheet.toggle()
                            }, dismissAction: {
                                withAnimation { showsSetupPlanCell.toggle() }
                            })
                        }
                    })
                }
            case .mood:
                Section {
                    if viewModel.appStateManager.isMoodExpanded {
                        MoodCellView(injectionRepository: viewModel.injectionRepository,
                                     hormoneManager: viewModel.hormoneLevelManager)
                    }
                } header: {
                    ExpandableSectionHeader(title: .moodTitle,
                                            expanded: $viewModel.appStateManager.isMoodExpanded)
                }
            case .currentLevel:
                Section(content: {
                    CurrentHormoneLevelCellView(injectionRepository: viewModel.injectionRepository,
                                                hormoneManager: viewModel.hormoneLevelManager)
                }, header: {
                    Text(feature.label)
                }, footer: {
                    if !viewModel.injectionRepository.allItems.isEmpty {
                        Text(.medicalDisclaimer)
                            .font(.footnote)
                    }
                })
            case .nextInjection:
                Section(feature.label) {
                    NextInjectionCellView(treatmentRepository: viewModel.treatmentPlanRepository,
                                          injectionRepository: viewModel.injectionRepository)
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
        .sheet(isPresented: $showsSetupPlanSheet, content: {
            NavigationStack {
                TreatmentPlanView(treatmentPlanRepository: viewModel.treatmentPlanRepository,
                                  hormoneLevelManager: viewModel.hormoneLevelManager)
                .navigationTitle("Setup Plan")
            }
        })
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
