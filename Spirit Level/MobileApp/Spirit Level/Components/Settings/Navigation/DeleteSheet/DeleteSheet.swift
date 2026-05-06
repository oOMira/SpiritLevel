import SwiftUI
import HealthDataLogging
import SpiritLevelShared
import OSLog

typealias DeleteSheetDependencies =
    HasAppStartRepository &
    HasAppStateManager &
    HasInjectionRepository &
    HasTreatmentPlanRepository &
    HasLabResultsRepository

struct DeleteSheet<Dependencies: DeleteSheetDependencies>: View {

    @Environment(\.dismiss) private var dismiss
    @State private var showsDeleteErrorAlert: Bool = false

    @State private var deleteFirstStart: Bool = false
    @State private var deleteAppConfiguration: Bool = false
    @State private var deleteAppLogData: Bool = false

    let dependencies: Dependencies

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
                .alert(.deleteErrorTitle, isPresented: $showsDeleteErrorAlert) {
                    Button(.okButtonTitle, role: .cancel) {
                        Logger.data.error("Failed to delete data")
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
        if deleteFirstStart { dependencies.appStartRepository.firstAppStart = nil }
        if deleteAppConfiguration {
            dependencies.appStateManager.searchHistoryData = ""
            dependencies.appStateManager.isMoodExpanded = true
            dependencies.appStateManager.selectedTab = 0
        }
        if deleteAppLogData {
            do {
                // Call `deleteAll()` on separate lines to make debugging easier.
                try dependencies.injectionRepository.deleteAll()
                try dependencies.treatmentPlanRepository.deleteAll()
                try dependencies.labResultsRepository.deleteAll()
            } catch {
                showsDeleteErrorAlert.toggle()
                shouldDismiss = false
                Logger.data.error("Failed to delete all data: \(error)")
                return
            }
        }
        if shouldDismiss { dismiss() }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let deleteErrorMessage: Self =
        "There was an issue deleting the data. Please try again later."
    static let deleteErrorTitle: Self = "Error Deleting Data"
    static let okButtonTitle: Self = "OK"
    static let deleteAppStart: Self = "Delete First Launch Date"
    static let deleteAppStartDescription: Self =
        "This will delete the date of the first app launch. This information is only relevant for achievements."
    static let deleteAppConfiguration: Self = "Delete App Data"
    static let deleteAppConfigurationDescription: Self =
        """
        This will delete things like closed or expanded sections and other small things that are not \
        critical for the app to work but make the experience more personal.
        """
    static let deleteDataTitle: Self = "Delete Data"
    static let deleteButtonTitle: Self = "Delete"
    static let closeLabelTitle: Self = "Close"
    static let deleteDataNavigationTitle: Self = "Delete Data"
    static let deleteDataDescription: Self =
        """
        This will delete all logged data, including injections, lab results, and other \
        items you have logged in the app.
        """
}

private extension String {
    static let xMark = "xmark"
}
