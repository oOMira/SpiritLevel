import SwiftData
import Foundation

public protocol ModelContextMockable {
    static func getMockModelContext(for types: any PersistentModel.Type...) -> ModelContext
}

extension ModelContextMockable {
    public static func getMockModelContext(for types: any PersistentModel.Type...) -> ModelContext {
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
