import SwiftData
import Foundation

@Model
class TreatmentPlan: Identifiable, Hashable {
    var id: UUID
    private var esterRawValue: String
    var name: String
    var frequency: Int
    var dosage: Double
    var firstInjectionDate: Date
    
    var ester: Ester {
        get { Ester(rawValue: esterRawValue) ?? .valerate }
        set { esterRawValue = newValue.rawValue }
    }

    init(name: String, ester: Ester, frequency: Int, dosage: Double, firstInjectionDate: Date) {
        self.id = UUID()
        self.esterRawValue = ester.rawValue
        self.frequency = frequency
        self.dosage = dosage
        self.firstInjectionDate = firstInjectionDate
        self.name = name
    }
}
