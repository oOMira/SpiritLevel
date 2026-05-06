import SwiftUI
import SwiftData
import HealthDataLogging

struct InjectionsListWatchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Injection.date, order: .reverse) private var injections: [Injection]

    var body: some View {
        List {
            if injections.isEmpty {
                Text("No injections logged yet")
            } else {
                ForEach(injections) { injection in
                    NavigationLink {
                        InjectionDetailWatchView(injection: injection)
                    } label: {
                        Text(injection.date, format: .dateTime.day().month().year())
                    }
                }
            }
        }
        .refreshable {
            await refresh()
        }
        .navigationTitle("Injections")
    }

    @MainActor
    private func refresh() async {
        try? modelContext.save()
    }
}
