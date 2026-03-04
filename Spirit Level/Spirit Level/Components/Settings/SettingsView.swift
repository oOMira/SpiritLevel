import SwiftUI

struct SettingsView<AppStartRepositoryType: AppStartManageable,
                    AppStateRepositoryType: AppStateManageable,
                    InjectionRepositoryType: InjectionManageable,
                    LabResultsRepositoryType: LabResultsManageable,
                    TreatmentPlanRepositoryType: TreatmentPlanManageable,
                    HormoneLevelManagerType: HormoneLevelManageable>: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingSheet: Bool = false
    
    let appStartRepository: AppStartRepositoryType
    let appStateRepository: AppStateRepositoryType
    let injectionRepository: InjectionRepositoryType
    let labResultsRepository: LabResultsRepositoryType
    let treatmentPlanRepository: TreatmentPlanRepositoryType
    let hormoneLevelManager: HormoneLevelManagerType
    
    var body: some View {
        List {
            ForEach(SettingsFeature.allCases) { feature in
                switch feature {
                case .plan:
                    Section {
                        NavigationLink {
                            TreatmentPlanView(treatmentPlanRepository: treatmentPlanRepository, hormoneLevelManager: hormoneLevelManager)
                        } label: {
                            TreatmentPlanCellView(treatmentPlanRepository: treatmentPlanRepository)
                        }
                    }
                case .support:
                    Section(.supportSectionTitle) {
                        SupportCellView()
                    }
                case .data:
                    Section("Used Resources") {
                        NavigationLink("Used Resources") {
                            UsedResourcesView()
                        }
                        NavigationLink {
                            let url = Bundle.main.url(forResource: "lottielicence", withExtension: "txt")!
                            let text = try! String(contentsOf: url, encoding: .utf8)
                            ScrollView {
                                Text(text)
                                    .padding()
                            }
                            .navigationTitle("Lottie License")
                            .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            Text("Lottie")
                        }
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
            DeleteSheet(appStartRepository: appStartRepository,
                        appStateRepository: appStateRepository,
                        injectionsRepository: injectionRepository,
                        treatmentPlanRepository: treatmentPlanRepository,
                        labResultsReportRepository: labResultsRepository)
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let settingsNavigationTitle: Self = "Settings"
    static let supportSectionTitle: Self = "Support"
    static let deleteDataButtonTitle: Self = "Delete Data"
}

private extension String {
    static let externalLinkSystemImage: Self = "square.and.arrow.up"
}
