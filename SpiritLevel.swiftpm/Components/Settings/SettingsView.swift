import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isSyncing: Bool = false
    @State private var isShowingSheet: Bool = false
    
    var body: some View {
        List {
            ForEach(SettingsFeature.allCases) { feature in
                switch feature {
                case .plan:
                    Section {
                        NavigationLink {
                            TreatmentPlanView()
                        } label: {
                            TreatmentPlanCellView()
                        }
                    }
                case .support:
                    Section(.supportSectionTitle) {
                        SupportCellView()
                    }
                case .data:
                    Section {
                        UsedDataCellView()
                    }
                case .deleteData:
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
            }
        }
        .navigationTitle(.settingsNavigationTitle)
        .sheet(isPresented: $isShowingSheet) {
            DeleteSheet(isShowingSheet: $isShowingSheet)
        }
    }
}

// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let settingsNavigationTitle: Self = "Settings"
    static let supportSectionTitle: Self = "Support"
    static let deleteDataButtonTitle: Self = "Delete Data"
}
