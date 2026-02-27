import SwiftUI

struct StatisticsView<InjectionRepositoryType: InjectionManagable>: View {
    let injectionRepository: InjectionRepositoryType
    
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
                        InjectionsCellView(injections: injectionRepository.allItems)
                    }
                case .injections:
                    Section(.labResultsSectionTitle) {
                        LabResultsCellView()
                    }
                }
            }
        }
        .navigationTitle(.navigationTitle)
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Statistics"
    static let injectionsSectionTitle: Self = "Injections"
    static let labResultsSectionTitle: Self = "Lab Results"
    static let labResultSampleData: Self = "200 pg on 21.01.2025"
    static let showMoreButton: Self = "Show more"
}
