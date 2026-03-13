import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.spiritlevel"

    /// Logs related to data persistence operations (SwiftData CRUD, repository errors)
    static let data = Logger(subsystem: subsystem, category: "Data")

    /// Logs related to app lifecycle events (startup, scene phase changes)
    static let app = Logger(subsystem: subsystem, category: "App")
}
