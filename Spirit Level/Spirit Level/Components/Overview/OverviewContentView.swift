import SwiftUI

// MARK: - ViewModel

typealias OverviewDependencies = HasAppStateManager & HasAppStartRepository & HasInjectionRepository & HasLabResultsRepository & HasTreatmentPlanRepository & HasHormoneLevelManager

@Observable
final class OverviewContentViewModel<Dependencies: OverviewDependencies> {
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - View

struct OverviewContentView<Dependencies: OverviewDependencies>: View {
    @Namespace var animationNamespace

    @Bindable private var viewModel: OverviewContentViewModel<Dependencies>

    @State private var showsSetupPlanCell: Bool = true
    @State private var showsSetupPlanSheet: Bool = false
    
    init(dependencies: Dependencies) {
        self.viewModel = .init(dependencies: dependencies)
    }
    
    var body: some View {
        List(OverviewFeature.allCases) { feature in
            // MARK: Content
            switch feature {
            case .reminders:
                Section(content: {
                    if showsSetupPlanCell {
                        RemindersCell(configuration: .init(
                            systemImageName: "calendar",
                            title: "Setup Plan",
                            description: "Description",
                            action: { withAnimation { showsSetupPlanSheet.toggle() } },
                            dismissAction: { withAnimation { showsSetupPlanCell.toggle() } } )
                        )
                        .matchedTransitionSource(id: "animation", in: animationNamespace)
                    }
                }, header: {
                    if [showsSetupPlanCell].contains(true) {
                        RemindersSectionHeader(title: .remindersSectionTitle, clearAction: {
                            withAnimation { showsSetupPlanCell.toggle() }
                        })
                    }
                })
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
                    AchievementsCellView(viewModel: .init(dependencies: viewModel.dependencies))
                        .accessibilityElement(children: .contain)
                } header: {
                    AchievementsHeader(title: feature.label, destination: {
                        AchievementsView(viewModel: .init(dependencies: viewModel.dependencies))
                    })
                }
            }
        }
        // MARK: Navigation
        .sheet(isPresented: $showsSetupPlanSheet, content: {
            NavigationStack {
                SelectTreatmentPlan(activePlan: nil,
                                    treatmentRepository: viewModel.dependencies.treatmentPlanRepository,
                                    treatmentPlanStore: .init(wrappedValue: .shared))
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        Button {
                            showsSetupPlanSheet.toggle()
                        } label: {
                            Label("close", systemImage: "xmark")
                        }
                    }
                }
            }
            .navigationTransition(.zoom(sourceID: "animation", in: animationNamespace))
        })
        .navigationTitle(.navigationTitle)
    }
}

// MARK: - UIComponents

private struct RemindersSectionHeader: View {
    private let title: LocalizedStringResource
    private let clearAction: () -> Void
    
    init(title: LocalizedStringResource, clearAction: @escaping () -> Void) {
        self.title = title
        self.clearAction = clearAction
    }
    
    var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityAddTraits(.isHeader)
            Button("Clear all", action: clearAction)
                .buttonStyle(.plain)
                .foregroundStyle(.accent)
        }
        .accessibilityElement(children: .contain)
    }
}

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
    static let accessibilityHint: Self = "Double tap to open details"
    static let navigationTitle: Self = "Overview"
    static let remindersSectionTitle: Self = "Reminders"
}
