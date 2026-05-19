import SwiftData
import Foundation
import OSLog

public enum SharedModelContainer {
    public static let appGroupIdentifier = "group.mkr.Spirit-Level"

    public static func create() throws -> ModelContainer {
        let config: ModelConfiguration

        if FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) != nil {
            config = ModelConfiguration(groupContainer: .identifier(appGroupIdentifier))
        } else {
            Logger.app.warning("App Group container not available, using default storage")
            config = ModelConfiguration()
        }

        return try ModelContainer(
            for: Injection.self,
            LabResult.self,
            TreatmentPlan.self,
            configurations: config
        )
    }
}
