import SwiftUI
import OSLog

struct InjectionsView<InjectionRepositoryType: InjectionManageable>: View {
    @State private var showsDeleteError: Bool = false
    let injectionRepository: InjectionRepositoryType
    
    var body: some View {
        let injections = injectionRepository.allItems
        List {
            if injections.isEmpty {
                Text(.noInjectionsMessage)
            } else {
                ForEach(injections) { injection in
                    Text("\(injection.dosage, specifier: .dosageFormat) mg \(injection.ester.shortName) on \(injection.date, format: .dateTime.day().month().year())")
                }
                .onDelete { offsets in
                    offsets.forEach {
                        do {
                            try injectionRepository.delete(item: injections[$0])
                        } catch {
                            showsDeleteError.toggle()
                        }
                    }
                }
            }
        }
        .animation(.easeInOut, value: injectionRepository.allItems.isEmpty)
        .toolbar {
            if !injectionRepository.allItems.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
            }
        }
        .navigationTitle("Injections")
        .alert(.showsDeleteErrorTitle, isPresented: $showsDeleteError) {
            Button(.okButtonTitle, role: .cancel) {
                Logger.data.error("Failed to delete injection")
            }
        } message: {
            Text(.showsDeleteErrorMessage)
        }

        .accessibilityElement(children: .contain)
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let showsDeleteErrorTitle: Self = "Error deleting injection"
    static let showsDeleteErrorMessage: Self = "There was an error deleting injection from database. Please try again later."
    static let okButtonTitle: Self = "OK"
    static let noInjectionsMessage: Self = "No injections logged yet"
}

private extension String {
    static let dosageFormat: Self = "%.1f"
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        InjectionsView(injectionRepository: Mocks.injectionsRepository)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        InjectionsView(injectionRepository: Mocks.injectionsRepository)
    }
    .preferredColorScheme(.dark)
}

