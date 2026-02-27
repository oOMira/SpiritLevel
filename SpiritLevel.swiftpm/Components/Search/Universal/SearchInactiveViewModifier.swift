import SwiftUI

// MARK: - Sheet Modifier

struct SearchInactiveViewModifier {
    struct SearchActiveActionsModifier<InjectionRepositoryType: InjectionManagable>: ViewModifier {
        let injectionRepository: InjectionRepositoryType
        @Binding var activeSheet: ShortcutFeature?

        func body(content: Content) -> some View {
            content
                .sheet(item: $activeSheet) { sheet in
                    switch sheet {
                    case .logInjection:
                        LogInjectionView(injecionRepository: injectionRepository)
                            .presentationDetents([.medium, .large])
                    case .logLab:
                        LogLabResultView()
                            .presentationDetents([.medium, .large])
                    }
                }
        }
    }

    // MARK: - Navigation Destination Modifier

    struct SearchActiveNavigationModifier<AppStateManagerType: AppStateManagable,
                                         InjectionRepositoryType: InjectionManagable>: ViewModifier {
        let appStateManager: AppStateManagerType
        let injectionReposetory: InjectionRepositoryType

        func body(content: Content) -> some View {
            content
                .navigationDestination(for: AppArea.self) { item in
                    switch item {
                    case .overview:    Overview(appStateManager: appStateManager, injectionRepository: injectionReposetory)
                    case .statisitcs:  StatisticsView(injectionRepository: injectionReposetory)
                    case .settings:    SettingsView()
                    }
                }
        }
    }

}
