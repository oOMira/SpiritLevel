import Foundation

extension Date {
    public var start: Date {
        Calendar.current.startOfDay(for: self)
    }
}
