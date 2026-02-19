import SwiftUI

struct StatisticsView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    StatisticsCellView()
                }
                
                Section("Injections") {
                    Text("5 mg EE on 21.01.2025")
                    Button("Show more") {
                        print("show more injections")
                    }
                }
                
                Section("Lab Results") {
                    Text("200 pg on 21.01.2025")
                    Button("Show more") {
                        print("show more lab results")
                    }
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

#Preview {
    StatisticsView()
}

