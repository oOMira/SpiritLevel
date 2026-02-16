import SwiftUI

struct StatisticsView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    StatisticsCellView()
                    Text("Expand")
                }
                
                Section("Injections") {
                    Text("Show more injections")
                }
                
                Section("Lab Results") {
                    Text("Show more results")
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

#Preview {
    StatisticsView()
}

