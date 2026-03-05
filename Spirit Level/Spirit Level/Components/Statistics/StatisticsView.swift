import SwiftUI

struct StatisticsView<InjectionRepositoryType: InjectionManageable,
                      LabResultsRepositoryType: LabResultsManageable>: View {
    
    @State private var editMode: EditMode = .inactive
    
    let injectionRepository: InjectionRepositoryType
    let labResultsRepository: LabResultsRepositoryType
    var body: some View {
        List {
            ForEach(StatisticsFeature.allCases) { feature in
                switch feature {
                case .labResults:
                    Section(.labResultsSectionTitle) {
                        LabResultsCellView(labResultsRepository: labResultsRepository)
                    }
                case .injections:
                    Section(.injectionsSectionTitle) {
                        InjectionsCellView(injectionRepository: injectionRepository)
                    }
                }
            }
        }
        .navigationTitle(.navigationTitle)
        .toolbar {
            if !injectionRepository.allItems.isEmpty || !labResultsRepository.allItems.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
            }
        }
        .environment(\.editMode, $editMode)
        .onChange(of: injectionRepository.allItems.isEmpty && labResultsRepository.allItems.isEmpty) { _, newValue in
            guard editMode.isEditing == true, newValue else { return }
            editMode = .inactive
        }
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Statistics"
    static let injectionsSectionTitle: Self = "Injections"
    static let labResultsSectionTitle: Self = "Lab Results"
    static let showMoreButton: Self = "Show more"
}
