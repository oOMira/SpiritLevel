import AppIntents

struct AppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: LogInjectionIntentQuickAction(),
                    phrases: [
                        "Open log injection in \(.applicationName)",
                        "Open log a new injection in \(.applicationName)"
                    ],
                    shortTitle: "Open Log Injection",
                    systemImageName: "syringe")

        AppShortcut(intent: LogLabResultIntentQuickAction(),
                    phrases: [
                        "Open log lab result in \(.applicationName)",
                        "Open log a new lab result in \(.applicationName)"
                    ],
                    shortTitle: "Open Log Lab Result",
                    systemImageName: "heart.text.clipboard")
    }
}
