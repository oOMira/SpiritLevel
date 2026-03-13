import SwiftUI
import SwiftData

#if DEBUG
struct Mocks {
    static let modelContainer: ModelContainer = {
        let config = ModelConfiguration()
        return try! ModelContainer(for: Injection.self,LabResult.self, TreatmentPlan.self, configurations: config)
    }()
}
#endif
