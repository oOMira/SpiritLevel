import SwiftData
import Foundation

struct OldInjection: Identifiable {
    let id = UUID()
    let ester: Ester
    let dosage: Double
    let date: Date
}

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
