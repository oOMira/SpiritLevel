import SwiftData

enum LocalModelContainer {
    static func create() throws -> ModelContainer {
        try ModelContainer(for: AppState.self,
                           AppStart.self,
                           configurations: .init(cloudKitDatabase: .none))
    }
}
