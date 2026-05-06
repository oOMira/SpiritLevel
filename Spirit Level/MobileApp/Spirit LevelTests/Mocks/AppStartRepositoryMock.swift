import Foundation
@testable import Spirit_Level

@Observable
@MainActor
class AppStartRepositoryMock: AppStartManageable {
    init(firstAppStart: Date? = nil) {
        self.firstAppStart = firstAppStart
    }

    var firstAppStart: Date?
}

extension AppStartRepositoryMock {
    static var existing: AppStartRepositoryMock {
        .init(firstAppStart: .distantPast)
    }

    static var new: AppStartRepositoryMock {
        .init(firstAppStart: nil)
    }
}
