import Foundation

struct Injection: Identifiable {
    let id = UUID()
    let ester: Ester
    let dosage: Double
    let date: Date
}
