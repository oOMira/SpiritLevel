import SwiftUI

// MARK: - View

struct StatisticsView<Dependencies: StatisticsDependencies>: View {
    
    @Bindable private var viewModel: StatisticsContentViewModel<Dependencies>
    
    init(dependencies: Dependencies) {
        self.viewModel = .init(dependencies: dependencies)
    }
    
    var body: some View {
        List {
            ForEach(StatisticsFeature.allCases) { feature in
                switch feature {
                case .chart:
                    Section(content: {
                        HormoneLevelHistoryView(viewModel: .init(dependencies: viewModel.dependencies))
                    }, header: {
                        Text(.visualizationTitle)
                    }, footer: {
                        if !viewModel.dependencies.injectionRepository.allItems.isEmpty {
                            Text(.medicalDisclaimer)
                        }
                    })
                case .injections:
                    Section(content: {
                        var displayedInjections: [Injection] {
                            let injections = viewModel.dependencies.injectionRepository.allItems
                            return Array(injections.prefix(.maxElementsToShow))
                        }
                        
                        if displayedInjections.isEmpty {
                            Text("No injections logged yet")
                        } else {
                            ForEach(displayedInjections) { injection in
                                Text("\(injection.dosage, specifier: .dosageFormat) mg \(injection.ester.shortName) on \(injection.date, format: .dateTime.day().month().year())")
                            }
                        }
                    }, header: {
                        NavigationSectionHeaderView(title: .injectionsSectionTitle, destination: {
                            InjectionsView(injectionRepository: viewModel.dependencies.injectionRepository)
                        })
                    })
                case .labResults:
                    Section(content: {
                        var displayedLabResults: [LabResult] {
                            let labResults = viewModel.dependencies.labResultsRepository.allItems
                            return Array(labResults.prefix(.maxElementsToShow))
                        }

                        if displayedLabResults.isEmpty {
                            Text("No results logged yet")
                        } else {
                            ForEach(displayedLabResults) { labResult in
                                Text("\(labResult.concentration.formatted(.number.precision(.fractionLength(0)))) pg on \(labResult.date, format: .dateTime.day().month().year())")
                            }
                        }
                    }, header: {
                        NavigationSectionHeaderView(title: .labResultsSectionTitle, destination: {
                            LabResultsView(labResultsRepository: viewModel.dependencies.labResultsRepository)
                        })
                    })
                }
            }
        }
        .navigationTitle(.navigationTitle)
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let trendsSectionTitle: Self = "Trends"
    static let navigationTitle: Self = "Statistics"
    static let injectionsSectionTitle: Self = "Injections"
    static let labResultsSectionTitle: Self = "Lab Results"
    static let showMoreButton: Self = "Show more"
    static let chartSectionTitle: Self = "Hormone Level Chart"
    static let medicalDisclaimer: Self = "This is no medical advice but a rough estimation"
    static let visualizationTitle: Self = "Visualization"
}

private extension Int {
    static let maxElementsToShow: Self = 3
}

private extension String {
    static let dosageFormat: Self = "%.1f"
}

// MARK: - Previews

#if DEBUG
#Preview("Light Mode") {
    NavigationStack {
        StatisticsView(dependencies: Mocks.appDependencies)
    }
    .environment(AppData())
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        StatisticsView(dependencies: Mocks.appDependencies)
    }
    .environment(AppData())
    .preferredColorScheme(.dark)
}
#endif

