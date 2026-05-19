import SwiftData
import Foundation

@Model
public class LabResult: Identifiable {
    public var id: UUID
    public var concentration: Double
    public var date: Date

    public init(concentration: Double, date: Date) {
        self.id = UUID()
        self.concentration = concentration
        self.date = date
    }
}
