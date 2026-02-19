import SwiftUI

struct StatisticsView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    StatisticsCellView()
                }
                
                Section("Injections") {
                    Button("Show more") {
                        print("show more injections")
                    }
                    .font(.footnote)
                }
                
                Section("Lab Results") {
                    Button("Show more") {
                        print("show more lab results")
                    }
                    .font(.footnote)
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

#Preview {
    StatisticsView()
}

