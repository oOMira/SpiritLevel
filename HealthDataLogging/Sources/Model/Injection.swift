import SwiftData
import Foundation

@Model
public class Injection: Identifiable {
    public var id: UUID = UUID()
    public var ester: Ester = Ester.valerate
    public var dosage: Double = 0
    public var date: Date = Date.now

    public init(ester: Ester, dosage: Double, date: Date) {
        self.id = UUID()
        self.ester = ester
        self.dosage = dosage
        self.date = date
    }
}
