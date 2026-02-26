import SwiftUI

// MARK: - Sheet Modifier

struct SearchInactiveViewModifier {
    struct SearchActiveActionsModifier: ViewModifier {
        @Binding var activeSheet: ShortcutFeature?

        func body(content: Content) -> some View {
            content
                .sheet(item: $activeSheet) { sheet in
                    switch sheet {
                    case .logInjection:
                        LogInjectionView()
                            .presentationDetents([.medium, .large])
                    case .logLab:
                        LogLabView()
                            .presentationDetents([.medium, .large])
                    }
                }
        }
    }

    // MARK: - Navigation Destination Modifier

    struct SearchActiveNavigationModifier<AppStateManagerType: AppStateManagable>: ViewModifier {
        let appStateManager: AppStateManagerType

        func body(content: Content) -> some View {
            content
                .navigationDestination(for: AppArea.self) { item in
                    switch item {
                    case .overview:    Overview(appStateManager: appStateManager)
                    case .statisitcs:  StatisticsView()
                    case .settings:    SettingsView()
                    }
                }
        }
    }

}
