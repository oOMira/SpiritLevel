import SwiftData
import Foundation

@Model
public class Injection: Identifiable {
    public var id: UUID
    public var dosage: Double
    public var date: Date
    public var ester: Ester

    public init(ester: Ester, dosage: Double, date: Date) {
        self.id = UUID()
        self.ester = ester
        self.dosage = dosage
        self.date = date
    }
}
