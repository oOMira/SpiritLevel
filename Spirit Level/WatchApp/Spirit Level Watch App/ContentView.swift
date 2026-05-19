import SwiftUI
import SwiftData
import SpiritLevelShared

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingLogInjection = false
    @State private var showingLogLab = false

    var body: some View {
        NavigationStack {
            List {
                Button {
                    showingLogInjection = true
                } label: {
                    Label("Log Injection", systemImage: "syringe")
                }

                Button {
                    showingLogLab = true
                } label: {
                    Label("Log Lab Result", systemImage: "heart.text.clipboard")
                }
            }
            .navigationTitle("Spirit Level")
            .sheet(isPresented: $showingLogInjection) {
                LogInjectionWatchView()
            }
            .sheet(isPresented: $showingLogLab) {
                LogLabResultWatchView()
            }
        }
    }
}
