import SwiftUI

// TODO: Disable future injections and past plans

struct AccessibleDatePicker: View {
    let range: ClosedRange<Date>
    let title: LocalizedStringResource
    @Binding private var selectedDate: Date
    
    init(title: LocalizedStringResource, selectedDate: Binding<Date>, range: ClosedRange<Date> = Date.distantPast...Date.distantFuture) {
        self.title = title
        self._selectedDate = selectedDate
        self.range = (range.lowerBound.start...range.upperBound.start)
    }

    var body: some View {
        DatePicker(title,
                   selection: $selectedDate,
                   in: range,
                   displayedComponents: .date)
        .accessibilityElement(children: .combine)
        .accessibilityValue(selectedDate.formatted(date: .abbreviated, time: .omitted))
        .accessibilityHint(.accessibilityHint)
    }
}

private extension LocalizedStringResource {
    static let accessibilityHint: Self = "Double tap to change"
}
