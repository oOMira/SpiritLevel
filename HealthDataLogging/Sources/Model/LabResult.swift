import SwiftData
import Foundation

@Model
public class LabResult: Identifiable {
    public var id: UUID = UUID()
    public var concentration: Double = 0
    public var date: Date = Date.now

    public init(concentration: Double, date: Date) {
        self.id = UUID()
        self.concentration = concentration
        self.date = date
    }
}
