import SwiftUI

struct StatisticsView<InjectionRepositoryType: InjectionManageable,
                      LabResultsRepositoryType: LabResultsManageable>: View {
    
    let injectionRepository: InjectionRepositoryType
    let labResultsRepository: LabResultsRepositoryType
    var body: some View {
        List {
            ForEach(StatisticsFeature.allCases) { feature in
                switch feature {
                case .labResults:
                    Section(.labResultsSectionTitle) {
                        InjectionsCellView(injectionRepository: injectionRepository)
                    }
                case .injections:
                    Section(.injectionsSectionTitle) {
                        LabResultsCellView(labResultsRepository: labResultsRepository)
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
