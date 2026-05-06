import SwiftUI
import HealthDataLogging

// MARK: - Sheet Modifier

struct QuickActionsNavigationViewModifier<InjectionRepo: InjectionManageable,
                                          LabResultsRepo: LabResultsManageable>: ViewModifier {
    let injectionRepository: InjectionRepo
    let labResultsRepository: LabResultsRepo
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

extension View {
    func quickActionsSheetDestination<T: InjectionManageable, U: LabResultsManageable>(
        activeSheet: Binding<ShortcutFeature?>,
        injectionRepository: T,
        labResultsRepository: U
    ) -> some View {
        modifier(QuickActionsNavigationViewModifier(
            injectionRepository: injectionRepository,
            labResultsRepository: labResultsRepository,
            activeSheet: activeSheet
        ))
    }
}
