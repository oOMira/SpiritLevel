import SwiftUI

struct TreatmentPlanHistory<TreatmentPlanReposetoryType: TreatmentPlanManageable>: View {
    @Environment(\.dismiss) private var dismiss
    let treatmentPlanRepository: TreatmentPlanReposetoryType
    @State private var showDeleteFailedAlert = false
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        let allItems = treatmentPlanRepository.allItems
        NavigationStack {
            List {
                if allItems.isEmpty {
                    Text("No treatment plan configured yet")
                } else {
                    ForEach(allItems) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.headline)
                            Text(String(format: "%.1f mg %@ every %d days", item.dosage, item.ester.name, item.frequency))
                            Text("First injection on \(item.firstInjectionDate, format: .dateTime.day().month().year())")
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let item = treatmentPlanRepository.allItems[index]
                            do {
                                try treatmentPlanRepository.delete(item: item)
                            } catch {
                                // TODO: Handle error appropriately (e.g., show an alert)
                            }
                        }
                    }
                }
            }
            .navigationTitle(.navigationBarTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !allItems.isEmpty {
                        EditButton()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Label(.closeButtonTitle, systemImage: .xMarkImage)
                    })
                    
                }
            }
            // TODO: Handle error appropriately
            .alert(.deleteFailedAlertTitle, isPresented: $showDeleteFailedAlert, actions: {
                Button("OK", role: .cancel) { showDeleteFailedAlert.toggle() }
            }, message: {
                Text(.deleteFailedAlertMessage)
            })
            .environment(\.editMode, $editMode)
            .onChange(of: allItems.isEmpty) { _, newValue in
                guard editMode.isEditing == true, newValue else { return }
                editMode = .inactive
            }
        }
    }
}

// MARK: - Constants

private extension String {
    static let xMarkImage: Self = "xmark"
}

private extension LocalizedStringResource {
    static let closeButtonTitle: Self = "Close"
    static let navigationBarTitle: Self = "History"
    static let deleteFailedAlertTitle: Self = "Failed to delete"
    static let deleteFailedAlertMessage: Self = "An error occurred while trying to delete the treatment plan. Please try again later."
}
