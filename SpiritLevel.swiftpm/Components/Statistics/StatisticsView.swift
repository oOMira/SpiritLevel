import SwiftUI

struct StatisticsView: View {
    var body: some View {
        List {
            ForEach(StatisticsFeature.allCases) { feature in
                switch feature {
                case .graph:
                    Section {
                        StatisticsCellView()
                    }
                case .labResults:
                    Section(.injectionsSectionTitle) {
                        Group {
                            Text(.injectionSampleData)
                            Text(.injectionSampleData)
                        }
                        .accessibilityElement(children: .contain)
                        Button(.showMoreButton) {
                            print("show more injections")
                        }
                    }
                case .injections:
                    Section(.labResultsSectionTitle) {
                        Group {
                            Text(.labResultSampleData)
                        }
                        .accessibilityElement(children: .contain)
                        Button(.showMoreButton) {
                            print("show more lab results")
                        }
                    }
                }
            }
        }
        .navigationTitle(.navigationTitle)
    }
}

// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let navigationTitle: Self = "Statistics"
    static let injectionsSectionTitle: Self = "Injections"
    static let injectionSampleData: Self = "5 mg EE on 21.01.2025"
    static let labResultsSectionTitle: Self = "Lab Results"
    static let labResultSampleData: Self = "200 pg on 21.01.2025"
    static let showMoreButton: Self = "Show more"
}
