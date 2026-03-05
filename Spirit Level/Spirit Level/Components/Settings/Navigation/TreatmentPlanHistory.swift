import SwiftUI

struct TreatmentPlanHistory: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Text("TreatmentPlanHistory")
            }
            .navigationTitle(.navigationBarTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Label(.closeButtonTitle, systemImage: .xMarkImage)
                    })
                }
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
}
