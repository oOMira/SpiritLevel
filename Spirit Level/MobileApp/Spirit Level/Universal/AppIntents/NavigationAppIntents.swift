import AppIntents

struct LogInjectionIntentQuickAction: AppIntent {
    static var title: LocalizedStringResource = "Open Log Injection"
    static var description: IntentDescription = "Open the Log Injection screen"
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        NavigationCoordinator.shared.activeQuickAction = .logInjection
        return .result()
    }
}

struct LogLabResultIntentQuickAction: AppIntent {
    static var title: LocalizedStringResource = "Open Log Lab Result"
    static var description: IntentDescription = "Open the Log Lab Result screen"
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        NavigationCoordinator.shared.activeQuickAction = .logLab
        return .result()
    }
}
