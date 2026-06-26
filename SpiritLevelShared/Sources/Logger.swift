import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.spiritlevel"

    public static let data = Logger(subsystem: subsystem, category: "Data")
    public static let app = Logger(subsystem: subsystem, category: "App")
}
