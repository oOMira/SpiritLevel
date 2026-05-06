import SwiftUI
import HealthDataLogging
import SpiritLevelShared
import OSLog

struct InjectionsView<InjectionRepo: InjectionManageable>: View {
    @State private var showsDeleteError: Bool = false
    let injectionRepository: InjectionRepo

    var body: some View {
        let injections = injectionRepository.allItems
        List {
            if injections.isEmpty {
                Text(.noInjectionsMessage)
            } else {
                ForEach(injections) { injection in
                    Text(injectionDescription(for: injection))
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
        .refreshable {
            injectionRepository.refresh()
        }
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

private extension InjectionsView {
    func injectionDescription(for injection: Injection) -> String {
        let formattedDose = String(format: String.dosageFormat, injection.dosage)
        let formattedDate = injection.date.formatted(.dateTime.day().month().year())
        return "\(formattedDose) mg \(injection.ester.shortName) on \(formattedDate)"
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let showsDeleteErrorTitle: Self = "Error Deleting Injection"
    static let showsDeleteErrorMessage: Self =
        "There was an error deleting the injection from the database. Please try again later."
    static let okButtonTitle: Self = "OK"
    static let noInjectionsMessage: Self = "No injections logged yet"
}

private extension String {
    static let dosageFormat: Self = "%.1f"
}
