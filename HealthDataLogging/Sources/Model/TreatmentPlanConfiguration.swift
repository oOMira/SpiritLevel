import SwiftData
import Foundation

@Model
public class TreatmentPlanConfiguration: Identifiable, Hashable {
    public var id: UUID = UUID()
    public var name: String = ""
    public var ester: Ester = Ester.valerate
    public var frequency: Int = 0
    public var dosage: Double = 0
    public var visible: Bool = true
    public var editable: Bool = true
    public var createdAt: Date = Date()

    public init(id: UUID = UUID(),
                name: String,
                ester: Ester,
                frequency: Int,
                dosage: Double,
                visible: Bool,
                editable: Bool,
                createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.ester = ester
        self.frequency = frequency
        self.dosage = dosage
        self.visible = visible
        self.editable = editable
        self.createdAt = createdAt
    }
}
