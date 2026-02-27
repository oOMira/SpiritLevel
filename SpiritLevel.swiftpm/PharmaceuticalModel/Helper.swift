import Foundation

extension Array where Element == Injection {
    var lastIterval: Double {
        let lastTwo = Array(suffix(2))
        return lastTwo[1].date.timeIntervalSince(lastTwo[0].date) / .magicNumbers.daysInSeconds
    }
}
