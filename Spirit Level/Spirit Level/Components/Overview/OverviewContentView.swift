import SwiftUI

// MARK: - OverviewDependencies

typealias OverviewDependencies = HasAppStateManager & HasAppStartRepository & HasInjectionRepository & HasLabResultsRepository & HasTreatmentPlanRepository & HasHormoneLevelManager

@Observable
final class OverviewContentViewModel<Dependencies: OverviewDependencies> {
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

struct OverviewContentView<Dependencies: OverviewDependencies>: View {
    @Namespace var animationNamespace

    @Bindable private var viewModel: OverviewContentViewModel<Dependencies>

    @State private var showsSetupPlanCell: Bool = true
    @State private var showsSetupPlanSheet: Bool = false
    @State private var showsDialog: Bool = false
    
    private let achievementsManager: AchievementsManager<Dependencies.InjectionRepositoryType,
                                                         Dependencies.TreatmentPlanRepositoryType,
                                                         Dependencies.LabResultsRepositoryType,
                                                         Dependencies.AppStartRepositoryType>
    
    init(dependencies: Dependencies) {
        self.viewModel = .init(dependencies: dependencies)
        self.achievementsManager = .init(injectionRepository: dependencies.injectionRepository,
                                         treatmentPlanRepository: dependencies.treatmentPlanRepository,
                                         labResultsRepository: dependencies.labResultsRepository,
                                         appStartRepository: dependencies.appStartRepository)
    }
    
    var body: some View {
        List(OverviewFeature.allCases) { feature in
            switch feature {
            case .reminders:
                Section(content: {
                    if showsSetupPlanCell {
                        RemindersCell(systemImageName: "calendar",
                                      title: "Setup Plan",
                                      description: "Setup a treatmentplan to get started",
                                      action: { showsSetupPlanSheet.toggle() },
                                      longPressAction: { showsDialog.toggle() })
                    }
                }, header: {
                    if [showsSetupPlanCell].contains(true) {
                        Text(.remindersSectionTitle)
                    }
                })
                .confirmationDialog("Are you sure?", isPresented: $showsDialog) {
                    Button("Clear") {
                        withAnimation { showsSetupPlanCell.toggle() }
                    }
                } message: {
                    Text("Clear Reminders Cell")
                }
            case .mood:
                Section {
                    if viewModel.dependencies.appStateManager.isMoodExpanded {
                        MoodCellView(injectionRepository: viewModel.dependencies.injectionRepository,
                                     hormoneManager: viewModel.dependencies.hormoneLevelManager)
                    }
                } header: {
                    ExpandableSectionHeader(title: .moodTitle,
                                            expanded: $viewModel.dependencies.appStateManager.isMoodExpanded)
                }
            case .currentLevel:
                Section(content: {
                    CurrentHormoneLevelCellView(injectionRepository: viewModel.dependencies.injectionRepository,
                                                hormoneManager: viewModel.dependencies.hormoneLevelManager)
                }, header: {
                    Text(feature.label)
                }, footer: {
                    if !viewModel.dependencies.injectionRepository.allItems.isEmpty {
                        Text(.medicalDisclaimer)
                            .font(.footnote)
                    }
                })
            case .nextInjection:
                Section(feature.label) {
                    NextInjectionCellView(treatmentRepository: viewModel.dependencies.treatmentPlanRepository,
                                          injectionRepository: viewModel.dependencies.injectionRepository)
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
                TreatmentPlanView(treatmentPlanRepository: viewModel.dependencies.treatmentPlanRepository,
                                  hormoneLevelManager: viewModel.dependencies.hormoneLevelManager)
                .navigationTitle("Setup Plan")
            }
        })
        .navigationTitle(.navigationTitle)
    }
}

// MARK: - AchievementsHeader

private struct AchievementsHeader<Destination: View>: View {
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

// MARK: - Constants

private extension LocalizedStringResource {
    static let moodTitle: Self = "Mood"
    static let medicalDisclaimer: Self = "This is no medical advice but a rough estimation"
    static let accessibilityHint: Self = "Double tap for details"
    static let navigationTitle: Self = "Overview"
    static let remindersSectionTitle: Self = "Reminders"
}
