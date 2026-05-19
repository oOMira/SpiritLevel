import SwiftData
import Foundation

@Model
public class TreatmentPlan: Identifiable, Hashable {
    public var id: UUID
    private var esterRawValue: String
    public var name: String
    public var frequency: Int
    public var dosage: Double
    public var firstInjectionDate: Date

    public var ester: Ester {
        get { Ester(rawValue: esterRawValue) ?? .valerate }
        set { esterRawValue = newValue.rawValue }
    }

    public init(name: String, ester: Ester, frequency: Int, dosage: Double, firstInjectionDate: Date) {
        self.id = UUID()
        self.esterRawValue = ester.rawValue
        self.frequency = frequency
        self.dosage = dosage
        self.firstInjectionDate = firstInjectionDate
        self.name = name
    }
}
