import SwiftUI

struct SelectTreatmentPlan: View {
    @State private var activePlan: Ester = .enanthate
    @State private var selectedDate = Date()
    
    var body: some View {
        List {
            Section("Choose Plan") {
                Picker(selection: $activePlan) {
                    ForEach(Ester.allCases, id: \.self) { ester in
                        Text(ester.name)
                    }
                } label: { EmptyView() }
                .pickerStyle(.inline)
                NavigationLink("Create own plan", destination: {
                    List {
                        Section("Configuration") {
                            CustomTreatmentPlanConfigurationView(ester: .enanthate)
                        }
                        Section {
                            Button(action: {
                                print("select")
                            }, label: {
                                Text("Set selected")
                                    .frame(maxWidth: .infinity)
                            })
                        }
                    }
                    .navigationTitle("Create your own plan")
                    .navigationBarTitleDisplayMode(.inline)
                })
            }
            Section("Start") {
                DatePicker("First Injection Date",
                           selection: $selectedDate,
                           displayedComponents: .date)

            }
            Section {
                Button(action: {
                    print("set plan")
                }, label: {
                    Text("Set Plan")
                        .frame(maxWidth: .infinity, alignment: .center)
                })
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Select Plan")
    }
}
