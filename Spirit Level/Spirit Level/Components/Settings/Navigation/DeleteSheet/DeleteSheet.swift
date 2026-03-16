import SwiftUI

struct DeleteSheet<AppStartRepositoryTyp: AppStartManageable,
                   AppStateRepositoryTyp: AppStateManageable,
                   InjectionsRepositoryType: InjectionManageable,
                   TreatmentPlanRepositoryType: TreatmentPlanManageable,
                   LabResultsReportRepositoryType: LabResultsManageable>: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var showsDeleteErrorAlert: Bool = false
    
    @State private var deleteFirstStart: Bool = false
    @State private var deleteAppConfiguration: Bool = false
    @State private var deleteAppLogData: Bool = false
    
    let appStartRepository: AppStartRepositoryTyp
    let appStateRepository: AppStateRepositoryTyp
    let injectionsRepository: InjectionsRepositoryType
    let treatmentPlanRepository: TreatmentPlanRepositoryType
    let labResultsReportRepository: LabResultsReportRepositoryType
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20, content: {
                    Group {
                        DeleteElement(title: .deleteAppStart,
                                      description: .deleteAppStartDescription,
                                      isOn: $deleteFirstStart)
                        
                        DeleteElement(title: .deleteAppConfiguration,
                                      description: .deleteAppConfigurationDescription,
                                      isOn: $deleteAppConfiguration)
                        
                        DeleteElement(title: .deleteDataTitle,
                                      description: .deleteDataDescription,
                                      isOn: $deleteAppLogData)
                    }
                    .accessibilityElement(children: .contain)
                    
                    Button(action: {
                        deleteButtonPressed()
                    }, label: {
                        Text(.deleteButtonTitle)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                    })
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                })
                .padding()
                // TODO: Add better error view alert on top of sheet untested
                .alert(.deleteErrorTitle, isPresented: $showsDeleteErrorAlert) {
                    Button(.okButtonTitle, role: .cancel) {
                        print("Error deleting injection from injectionRepository")
                    }
                } message: {
                    Text(.deleteErrorMessage)
                }
            }
            .navigationTitle(.deleteDataNavigationTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Label(.closeLabelTitle, systemImage: .xMark)
                    }
                }
            }
        }
    }
    
    private func deleteButtonPressed() {
        var shouldDismiss = true
        if deleteFirstStart { appStartRepository.firstAppStart = nil }
        if deleteAppConfiguration {
            appStateRepository.searchHistoryData = ""
            appStateRepository.isMoodExpanded = true
            appStateRepository.selectedTab = 0
        }
        if deleteAppLogData {
            do {
                // deleteAll() called in single lines to enable better debugging
                // TODO: potentially saves context 3 times might be a problem in the future
                try injectionsRepository.deleteAll()
                try treatmentPlanRepository.deleteAll()
                try labResultsReportRepository.deleteAll()
            } catch {
                showsDeleteErrorAlert.toggle()
                shouldDismiss = false
                print("error deleting all data")
                return
            }
        }
        if shouldDismiss { dismiss() }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let deleteErrorMessage: Self = "There was an issue deleting the data. Please try again later."
    static let deleteErrorTitle: Self = "Error Deleting Data"
    static let okButtonTitle: Self = "OK"
    static let deleteAppStart: Self = "Delete First App Start"
    static let deleteAppStartDescription: Self = "This will delete the date of the first app start. This information is only relevant for achievements"
    static let deleteAppConfiguration: Self = "Delete App Data"
    static let deleteAppConfigurationDescription: Self = "This will delete things like closed or expanded sections and other small things that are not critical for the app to work but make the experience more personal."
    static let deleteDataTitle: Self = "Delete Data"
    static let deleteButtonTitle: Self = "Delete"
    static let closeLabelTitle: Self = "Close"
    static let deleteDataNavigationTitle: Self = "Delete Data"
    static let deleteDataDescription: Self = "This will delete all logged data like injections, lab results other things that you have logged in the app."
}

private extension String {
    static let xMark = "xmark"
}
