import SwiftUI
import HealthDataLogging
import SwiftData

#if DEBUG
struct Mocks {
    static let modelContainer: ModelContainer = {
        let config = ModelConfiguration()
        do {
            return try ModelContainer(
                for: Injection.self,
                LabResult.self,
                TreatmentPlan.self,
                configurations: config
            )
        } catch {
            fatalError("Failed to create mock model container: \(error)")
        }
    }()
}
#endif
