import SwiftUI
import SwiftData
import HealthDataLogging

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    LogInjectionWatchView()
                } label: {
                    Label("Log Injection", systemImage: "syringe")
                }

                NavigationLink {
                    InjectionsListWatchView()
                } label: {
                    Label("View Injections", systemImage: "calendar")
                }

                NavigationLink {
                    LogLabResultWatchView()
                } label: {
                    Label("Log Lab Result", systemImage: "heart.text.clipboard")
                }

                NavigationLink {
                    LabResultsListWatchView()
                } label: {
                    Label("View Lab Results", systemImage: "chart.line.uptrend.xyaxis")
                }
            }
            .navigationTitle("Spirit Level")
        }
    }
}
