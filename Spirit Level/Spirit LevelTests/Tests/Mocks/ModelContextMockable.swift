import SwiftData
import Foundation
@testable import Spirit_Level

protocol ModelContextMockable {
    static func getMockModelContext(for types: any PersistentModel.Type...) -> ModelContext
}

extension ModelContextMockable {
    static func getMockModelContext(for types: any PersistentModel.Type...) -> ModelContext {
        let schema = Schema(types)
        let container = try! ModelContainer(for: schema, configurations: ModelConfiguration.getInMemory())
        return ModelContext(container)
    }
}

// MARK: - Helper

private extension ModelConfiguration {
    static func getInMemory() -> ModelConfiguration {
        .init(isStoredInMemoryOnly: true)
    }
}
