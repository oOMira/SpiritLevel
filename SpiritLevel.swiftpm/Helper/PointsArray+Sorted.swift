import Foundation

extension Array where Element == Point {
    var sorted: Self { sorted { $0.x < $1.x } }
}
