import SwiftUI

// MARK: - Sheet Modifier

struct SearchInactiveViewModifier {
    struct SearchActiveActionsModifier<InjectionRepositoryType: InjectionManageable,
                                       LabResultsRepositoryType: LabResultsManageable>: ViewModifier {
        let injectionRepository: InjectionRepositoryType
        let labResultsRepository: LabResultsRepositoryType
        @Binding var activeSheet: ShortcutFeature?
        
        func body(content: Content) -> some View {
            content
                .sheet(item: $activeSheet) { sheet in
                    switch sheet {
                    case .logInjection:
                        LogInjectionView(injectionRepository: injectionRepository)
                            .presentationDetents([.medium, .large])
                    case .logLab:
                        LogLabResultView(labResultsRepository: labResultsRepository)
                            .presentationDetents([.medium, .large])
                    }
                }
        }
    }
}
