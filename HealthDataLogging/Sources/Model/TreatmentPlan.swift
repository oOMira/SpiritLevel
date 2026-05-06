import SwiftData
import Foundation

@Model
public class TreatmentPlan: Identifiable, Hashable {
    public var id: UUID = UUID()
    public var name: String = ""
    public var ester: Ester = Ester.valerate
    public var frequency: Int = 0
    public var dosage: Double = 0
    public var firstInjectionDate: Date = Date.now

    public init(name: String, ester: Ester, frequency: Int, dosage: Double, firstInjectionDate: Date) {
        self.id = UUID()
        self.name = name
        self.ester = ester
        self.frequency = frequency
        self.dosage = dosage
        self.firstInjectionDate = firstInjectionDate
    }
}
