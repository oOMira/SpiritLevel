import SwiftData
import Foundation

@Model
class LabResult: Identifiable {
    var id: UUID
    var concentration: Double
    var date: Date

    init(concentration: Double, date: Date) {
        self.id = UUID()
        self.concentration = concentration
        self.date = date
    }
}
