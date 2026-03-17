import SwiftUI

// MARK: - View

struct StatisticsView<Dependencies: StatisticsDependencies>: View {
    
    let dependencies: Dependencies
    
    var body: some View {
        StatisticsContentView(dependencies: dependencies)
    }
}

struct StatisticsContentView<Dependencies: StatisticsDependencies>: View {
    
    @Bindable private var viewModel: StatisticsContentViewModel<Dependencies>
    @State private var editMode: EditMode = .inactive
    
    init(dependencies: Dependencies) {
        self.viewModel = .init(dependencies: dependencies)
    }
    
    var body: some View {
        List {
            ForEach(StatisticsFeature.allCases) { feature in
                switch feature {
                case .chart:
                    if !editMode.isEditing {
                        Section(content: {
                            VStack {
                                HormoneLevelChartCell(injectionRepository: viewModel.dependencies.injectionRepository,
                                                      hormoneManager: viewModel.dependencies.hormoneLevelManager)
                            }
                        }, header: {
                            Text(.visualizationTitle)
                        }, footer: {
                            if !viewModel.dependencies.injectionRepository.allItems.isEmpty {
                                Text(.medicalDisclaimer)
                            } else {
                                Text("Visualization will be available once you have logged at least one injection")
                            }
                        })
                    }
                case .labResults:
                    Section(.labResultsSectionTitle) {
                        LabResultsCellView(labResultsRepository: viewModel.dependencies.labResultsRepository)
                    }
                case .injections:
                    Section(.injectionsSectionTitle) {
                        InjectionsCellView(injectionRepository: viewModel.dependencies.injectionRepository)
                    }
                case .history:
                    if !editMode.isEditing {
                        Section("History") {
                            Text("History")
                        }
                    }
                case .trends:
                    if !editMode.isEditing {
                        Section("Trends") {
                            Text("Trends")
                        }
                    }
                }
            }
        }
        .navigationTitle(.navigationTitle)
        .toolbar {
            if !viewModel.dependencies.injectionRepository.allItems.isEmpty || !viewModel.dependencies.labResultsRepository.allItems.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
            }
        }
        .environment(\.editMode, $editMode)
        .onChange(of: viewModel.dependencies.injectionRepository.allItems.isEmpty && viewModel.dependencies.labResultsRepository.allItems.isEmpty) { _, newValue in
            guard editMode.isEditing == true, newValue else { return }
            editMode = .inactive
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Statistics"
    static let injectionsSectionTitle: Self = "Injections"
    static let labResultsSectionTitle: Self = "Lab Results"
    static let showMoreButton: Self = "Show more"
    static let chartSectionTitle: Self = "Hormone Level Chart"
    static let medicalDisclaimer: Self = "This is no medical advice but a rough estimation"
    static let visualizationTitle: Self = "Visualization"
}
