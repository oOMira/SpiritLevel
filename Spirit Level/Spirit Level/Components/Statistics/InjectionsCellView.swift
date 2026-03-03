import SwiftUI

struct InjectionsCellView<InjectionRepositoryType: InjectionManageable>: View {
    @State private var showsDeleteError: Bool = false
    @State private var expanded = false
    let injectionRepository: InjectionRepositoryType
    
    var body: some View {
        let injections = injectionRepository.allItems
        let displayedInjections = expanded ? injections : Array(injections.prefix(.maxInjectionsToShow))
        Group {
            if injections.isEmpty {
                Text(.noInjectionsMessage)
            } else {
                ForEach(displayedInjections) { injection in
                    Text("\(injection.dosage, specifier: .dosageFormat) mg \(injection.ester.shortName) on \(injection.date, format: .dateTime.day().month().year())")
                }
                .onDelete { offsets in
                    offsets.forEach {
                        do {
                            try injectionRepository.delete(item: displayedInjections[$0])
                        } catch {
                            showsDeleteError.toggle()
                        }
                    }
                }
            }
        }
        .alert(.showsDeleteErrorTitle, isPresented: $showsDeleteError) {
            Button(.okButtonTitle, role: .cancel) {
                print("Error deleting injection from injectionRepository")
            }
        } message: {
            Text(.showsDeleteErrorMessage)
        }

        .accessibilityElement(children: .contain)
        if injections.count > .maxInjectionsToShow {
            Button(action: {
                withAnimation { expanded.toggle() }
            }, label: {
                AccessibleCollapseButton(expanded: $expanded)
            })
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let showsDeleteErrorTitle: Self = "Error deleting injection"
    static let showsDeleteErrorMessage: Self = "There was an error deleting injection from database. Please try again later."
    static let okButtonTitle: Self = "OK"
    static let noInjectionsMessage: Self = "No injections logged yet"
}

private extension Int {
    static let maxInjectionsToShow: Self = 3
}

private extension String {
    static let dosageFormat: Self = "%.1f"
}
    
