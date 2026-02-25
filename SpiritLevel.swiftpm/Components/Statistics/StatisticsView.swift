import SwiftUI

struct StatisticsView: View {
    var body: some View {
        List {
            Section {
                StatisticsCellView()
            }
            
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
        .navigationTitle(.navigationTitle)
    }
}

// MARK: - Constants

private extension LocalizedStringKey {
    static let navigationTitle: Self = "Statistics"
    static let injectionsSectionTitle: Self = "Injections"
    static let injectionSampleData: Self = "5 mg EE on 21.01.2025"
    static let labResultsSectionTitle: Self = "Lab Results"
    static let labResultSampleData: Self = "200 pg on 21.01.2025"
    static let showMoreButton: Self = "Show more"
}

// MARK: - Preview
#Preview("Light Mode") {
    NavigationStack {
        StatisticsView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        StatisticsView()
    }
    .preferredColorScheme(.dark)
}


