import SwiftUI

struct SettingsView: View {
    @State var isSyncing: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        Text("new")
                    } label: {
                        Text("Treatment Plan")
                    }
                }
                Section("Support") {
                    SupportSection()
                }
                Section("Data Managment") {
                    HStack {
                        Text("Sync")
                        Toggle("Sync", isOn: $isSyncing)
                    }
                    HStack {
                        Text("Import")
                        Spacer()
                        Button {
                            print("import")
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                                .font(.title2)
                        }
                        .buttonStyle(.plain)
                    }
                    HStack {
                        Text("Export")
                        Spacer()
                        Button {
                            print("export")
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Section {
                    Button {
                        print("delete")
                    } label: {
                        Text("Delete Data")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
