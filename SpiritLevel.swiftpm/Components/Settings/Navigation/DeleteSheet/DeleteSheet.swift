import SwiftUI

struct DeleteSheet: View {
    @Binding var isShowingSheet: Bool
    @State private var deleteAppConfiguration: Bool = true
    @State private var deleteAppLogData: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20, content: {
                    DeleteElement(title: .deleteAppConfiguration,
                                  description: .deleteAppConfigurationDescription,
                                  isOn: $deleteAppConfiguration)
                    
                    DeleteElement(title: .deleteDataTitle,
                                  description: .deleteDataDescription,
                                  isOn: $deleteAppLogData)
                    
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
        .presentationDetents([.medium, .large])
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let deleteAppConfiguration: Self = "Delete App Data"
    static let deleteAppConfigurationDescription: Self = "This will delete things like closed or expanded sections, onboarding status and other small things that are not critical for the app to work but make the experience more personal."
    static let deleteDataTitle: Self = "Delete Data"
    static let deleteButtonTitle: Self = "Delete"
    static let closeLabelTitle: Self = "Close"
    static let deleteDataNavigationTitle: Self = "Delete Data"
    static let deleteDataDescription: Self = "This will delete all logged data like injections, lab results other things that you have logged in the app."
}

private extension String {
    static let xMark = "xmark"
}
