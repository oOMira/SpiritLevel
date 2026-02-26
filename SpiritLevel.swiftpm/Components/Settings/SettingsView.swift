import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isSyncing: Bool = false
    @State private var isShowingSheet: Bool = false
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    TreatmentPlanView()
                } label: {
                    TreatmentPlanCellView()
                }
            }
            Section(.supportSectionTitle) {
                SupportSection()
            }
            
            Section {
                Button {
                    isShowingSheet.toggle()
                } label: {
                    Text(.deleteDataButtonTitle)
                        .font(.title3)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle(.settingsNavigationTitle)
        .sheet(isPresented: $isShowingSheet) {
            DeleteSheet(isShowingSheet: $isShowingSheet)
        }
    }
}

extension SettingsView {
    struct DeleteSheet: View {
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
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
                            Text(.deleteButtonTitle)
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
            .presentationDetents(horizontalSizeClass == .compact
                                 ? [.large]
                                 : [.medium])
        }
    }
}


// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let settingsNavigationTitle: Self = "Settings"
    static let supportSectionTitle: Self = "Support"
    static let dataManagementSectionTitle: Self = "Data Managment"
    static let iCloudSyncingToggle: Self = "iCloud Syncing"
    static let deleteDataButtonTitle: Self = "Delete Data"
    static let deleteDataTitle: Self = "Delete App Configuration"
    static let deleteAppConfiguration: Self = "Delete App Data"
    static let deleteDataDescription: Self = "This will delete all logged data like injections, lab results other things that you have logged in the app."
    static let deleteAppConfigurationDescription: Self = "This will delete things like closed or expanded sections, onboarding status and other small things that are not critical for the app to work but make the experience more personal."
    static let deleteDataNavigationTitle: Self = "Delete Data"
    static let closeLabelTitle: Self = "Close"
    static let deleteButtonTitle: Self = "Delete"
}

private extension String {
    static let xMark = "xmark"
    static let trayDownIcon = "tray.and.arrow.down"
    static let trayUpIcon = "tray.and.arrow.up"
}
