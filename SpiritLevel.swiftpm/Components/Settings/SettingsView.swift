import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @State var isSyncing: Bool = false
    @State var isShowingSheet: Bool = false
    
    @State var isShowingDeleteConfiguration: Bool = false
    @State var isShowingDeleteData: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        TreatmentPlanView()
                    } label: {
                        TreatmentPlanCellView()
                    }
                }
                Section("Support") {
                    SupportSection()
                }
                Section("Data Managment") {
                    HStack {
                        Toggle("iCloud Syncing", isOn: $isSyncing)
                    }
                    HStack {
                        Text("Import")
                        Spacer()
                        Button {
                            print("import")
                        } label: {
                            Image(systemName: "tray.and.arrow.down")
                        }
                        .buttonStyle(.plain)
                    }
                    HStack {
                        Text("Export")
                        Spacer()
                        Button {
                            print("export")
                        } label: {
                            Image(systemName: "tray.and.arrow.up")
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Section {
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        Text("Delete Data")
                            .font(.title3)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .sheet(isPresented: $isShowingSheet) {
            DeleteSheet(isShowingSheet: $isShowingSheet)
        }
    }
}

extension SettingsView {
    struct DeleteSheet: View {
        @Binding var isShowingSheet: Bool
        @State private var deleteAppConfiguration: Bool = true
        @State private var deleteAppLogData: Bool = false
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20, content: {
                        Toggle(.deleteAppConfiguration, isOn: $deleteAppConfiguration)
                        Text(.deleteAppConfigurationDescription)
                            .font(.footnote)
                        Toggle(.deleteDataTitle, isOn: $deleteAppLogData)
                        Text(.deleteDataDescription)
                            .font(.footnote)
                        Button(action: {
                            withAnimation { isShowingSheet.toggle() }
                        }, label: {
                            Text("Delete")
                                .frame(maxWidth: .infinity)
                                .padding(8)
                        })
                        .buttonStyle(.borderedProminent)
                    })
                    .padding()
                }
                .navigationTitle(.deleteDataNavigationTitle)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation { isShowingSheet.toggle() }
                        } label: {
                            Label(.closeLabelTitle, systemImage: .xMark)
                        }
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
}


extension LocalizedStringKey {
    static let deleteDataTitle: Self = "Delete App Configuration"
    static let deleteAppConfiguration: Self = "Delete App Data"
    static let deleteDataDescription: Self = "This will delete all logged data like injections, lab results other things that you have logged in the app."
    static let deleteAppConfigurationDescription: Self = "This will delete things like closed or expanded sections, onboarding status and other small things that are not critical for the app to work but make the experience more personal."
    static let deleteDataNavigationTitle: Self = "Delete Data"
    static let closeLabelTitle: Self = "Close"
}

extension String {
    static let xMark = "xmark"
}

#Preview {
    SettingsView()
}
