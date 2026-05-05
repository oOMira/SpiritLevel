import Foundation

@MainActor
@Observable
final class NavigationCoordinator {
    static let shared = NavigationCoordinator()

    var activeQuickAction: ShortcutFeature?

    func showQuickAction(_ quickAction: ShortcutFeature, appStateRepository: some AppStateManageable) {
        appStateRepository.selectedTab = AppArea.overview.tabIndex ?? 0
        activeQuickAction = quickAction
    }

    func handle(_ url: URL, appStateRepository: some AppStateManageable) {
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        let route = url.host ?? pathComponents.first
        let target = url.host == nil ? pathComponents.element(at: 1) : pathComponents.first

        switch route {
        case "tab":
            guard let target,
                  let area = AppArea(rawValue: target) else { return }
            appStateRepository.selectedTab = area.tabIndex ?? 0
        case "quick":
            guard let target,
                  let quickAction = ShortcutFeature(rawValue: target) else { return }
            showQuickAction(quickAction, appStateRepository: appStateRepository)
        default:
            return
        }
    }
}
