import SwiftUI

// MARK: - View

struct OverviewContentView<Dependencies: OverviewDependencies>: View {
    @Namespace var animationNamespace

    @Bindable private var viewModel: OverviewContentViewModel<Dependencies>
    
    init(dependencies: Dependencies) {
        self.viewModel = .init(dependencies: dependencies)
    }
    
    var body: some View {
        List(OverviewFeature.allCases) { feature in
            // MARK: Content
            switch feature {
            case .reminders:
                Section(content: {
                    ForEach(viewModel.reminders.filter(\.showsCell)) {
                        RemindersCell(configuration: $0.cellConfiguration)
                            .matchedTransitionSource(id: $0.id, in: animationNamespace)
                    }
                }, header: {
                    if viewModel.reminders.contains(where: { $0.showsCell }) {
                        RemindersSectionHeader(title: .remindersSectionTitle, clearAction: {
                            withAnimation { viewModel.reminders.forEach { $0.showsCell = false } }
                        })
                    }
                })
            case .mood:
                Section {
                    if viewModel.dependencies.appStateManager.isMoodExpanded {
                        MoodCellView(dependencies: viewModel.dependencies)
                    }
                } header: {
                    ExpandableSectionHeader(title: .moodTitle,
                                            expanded: $viewModel.dependencies.appStateManager.isMoodExpanded)
                }
            case .currentLevel:
                Section(content: {
                    CurrentHormoneLevelCellView(viewModel: .init(dependencies: viewModel.dependencies))
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
                    NextInjectionCellView(viewModel: .init(dependencies: viewModel.dependencies))
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
        .sheet(item: $viewModel.visibleReminder, content: { reminder in
            NavigationStack {
                SelectTreatmentPlan(activePlan: nil,
                                    treatmentRepository: viewModel.dependencies.treatmentPlanRepository,
                                    treatmentPlanStore: .init(wrappedValue: .shared))
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        Button {
                            viewModel.visibleReminder = nil
                        } label: {
                            Label("close", systemImage: "xmark")
                        }
                    }
                }
            }
            .navigationTransition(.zoom(sourceID: reminder.id, in: animationNamespace))
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

// MARK: - Helper

private extension OverviewContentViewModel.ReminderConfiguration {
    var cellConfiguration: RemindersCell.Configuration {
        let action: () -> Void = { [weak self] in
            guard let self else { return }
            self.action(self)
        }
        
        return .init(systemImageName: systemImageName,
                     title: title,
                     description: description,
                     action: action,
                     dismissAction: dismissAction)
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
