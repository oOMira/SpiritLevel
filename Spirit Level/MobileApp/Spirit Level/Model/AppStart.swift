import Foundation
import SwiftData

@Model
final class AppStart {
    var firstAppStart: Date?

    init(firstAppStart: Date? = nil) {
        self.firstAppStart = firstAppStart
    }
}
