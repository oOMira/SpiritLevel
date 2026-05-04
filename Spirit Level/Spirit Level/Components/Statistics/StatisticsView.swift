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
                                Text(injectionDescription(for: injection))
                            }
                        }
                    }, header: {
                        NavigationSectionHeaderView(title: .injectionsSectionTitle) {
                            InjectionsView(
                                injectionRepository: viewModel.dependencies.injectionRepository
                            )
                        }
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
                                Text(labResultDescription(for: labResult))
                            }
                        }
                    }, header: {
                        NavigationSectionHeaderView(title: .labResultsSectionTitle) {
                            LabResultsView(
                                labResultsRepository: viewModel.dependencies.labResultsRepository
                            )
                        }
                    })
                }
            }
        }
        .navigationTitle(.navigationTitle)
    }
}

private extension StatisticsView {
    func injectionDescription(for injection: Injection) -> String {
        let formattedDose = String(format: String.dosageFormat, injection.dosage)
        let formattedDate = injection.date.formatted(.dateTime.day().month().year())
        return "\(formattedDose) mg \(injection.ester.shortName) on \(formattedDate)"
    }

    func labResultDescription(for labResult: LabResult) -> String {
        let formattedConcentration = labResult.concentration.formatted(
            .number.precision(.fractionLength(0))
        )
        let formattedDate = labResult.date.formatted(.dateTime.day().month().year())
        return "\(formattedConcentration) pg/mL on \(formattedDate)"
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
    static let medicalDisclaimer: Self =
        "This is not medical advice, but a rough estimate."
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
