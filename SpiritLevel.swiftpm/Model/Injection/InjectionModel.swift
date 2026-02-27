import SwiftData
import Foundation

@Model
class Injection: Identifiable {
    var id: UUID
    var ester: Ester
    var dosage: Double
    var date: Date

    init(ester: Ester, dosage: Double, date: Date) {
        self.id = UUID()
        self.ester = ester
        self.dosage = dosage
        self.date = date
    }
}
