import Foundation

struct Point: Identifiable {
    var id = UUID()
    let x: Double
    let y: Double
    
    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
}
