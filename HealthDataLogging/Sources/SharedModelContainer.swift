import SwiftData

public enum SharedModelContainer {
    public static let cloudKitContainerIdentifier = "iCloud.mkr.Spirit-Level"

    public static func create() throws -> ModelContainer {
        try ModelContainer(
            for: Injection.self,
            LabResult.self,
            TreatmentPlan.self,
            TreatmentPlanConfiguration.self,
            configurations: ModelConfiguration(
                cloudKitDatabase: .private(cloudKitContainerIdentifier)
            )
        )
    }
}
