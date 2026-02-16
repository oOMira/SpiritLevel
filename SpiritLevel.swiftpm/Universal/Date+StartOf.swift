import Foundation

extension Date {
    var start: Date {
        Calendar.current.startOfDay(for: self)
    }
}
