import SwiftUI

// MARK: - View

struct SettingsView<Dependencies: SettingsDependencies>: View {
    
    let dependencies: Dependencies
    
    var body: some View {
        SettingsContentView(dependencies: dependencies)
    }
}

struct SettingsContentView<Dependencies: SettingsDependencies>: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable private var viewModel: SettingsContentViewModel<Dependencies>
    @State private var isShowingSheet: Bool = false
    
    init(dependencies: Dependencies) {
        self.viewModel = .init(dependencies: dependencies)
    }
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    TreatmentPlanView(dependencies: viewModel.dependencies)
                } label: {
                    TreatmentPlanCellView(treatmentPlanRepository: viewModel.dependencies.treatmentPlanRepository)
                }
            }
            
            Section(.supportSectionTitle) {
                SupportCellView()
            }
            
            Section("Used Resources") {
                ForEach(Acknowledgment.allCases) { acknowledgment in
                    NavigationLink {
                        AcknowledgementView(acknowledgment: acknowledgment)
                    } label: {
                        Text(acknowledgment.navigationTitle)
                    }
                }
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
            DeleteSheet(dependencies: viewModel.dependencies)
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

private extension Acknowledgment {
    var navigationTitle: LocalizedStringResource {
        switch self {
        case .lottie: return "Lottie"
        case .animtadEmojis: return "Animated Noto Emoji"
        }
    }
}
