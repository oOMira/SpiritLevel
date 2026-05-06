import SwiftUI
import SwiftData
import HealthDataLogging

struct LabResultsListWatchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \LabResult.date, order: .reverse) private var labResults: [LabResult]

    var body: some View {
        List {
            if labResults.isEmpty {
                Text("No lab results logged yet")
            } else {
                ForEach(labResults) { labResult in
                    NavigationLink {
                        LabResultDetailWatchView(labResult: labResult)
                    } label: {
                        Text(labResult.date, format: .dateTime.day().month().year())
                    }
                }
            }
        }
        .refreshable {
            await refresh()
        }
        .navigationTitle("Lab Results")
    }

    @MainActor
    private func refresh() async {
        try? modelContext.save()
    }
}
