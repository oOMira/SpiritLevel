import SwiftData
import Foundation

@Model
class Injection: Identifiable {
    var id: UUID
    var dosage: Double
    var date: Date
    var ester: Ester

    init(ester: Ester, dosage: Double, date: Date) {
        self.id = UUID()
        self.ester = ester
        self.dosage = dosage
        self.date = date
    }
}
