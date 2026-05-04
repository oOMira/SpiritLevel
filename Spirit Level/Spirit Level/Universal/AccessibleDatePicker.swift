import SwiftUI

/// A date picker with built-in accessibility support that normalizes dates to the start of day.
///
/// Wraps `DatePicker` and adds a formatted VoiceOver value and interaction hint.
struct AccessibleDatePicker: View {
    /// The allowed date range for selection, normalized to start-of-day boundaries.
    let range: ClosedRange<Date>
    /// The localized label displayed alongside the picker.
    let title: LocalizedStringResource
    /// The currently selected date.
    @Binding private var selectedDate: Date

    /// Creates an accessible date picker.
    /// - Parameters:
    ///   - title: The localized label for the picker.
    ///   - selectedDate: A binding to the selected date value.
    ///   - range: The allowed date range. Defaults to the full range of representable dates.
    init(
        title: LocalizedStringResource,
        selectedDate: Binding<Date>,
        range: ClosedRange<Date> = Date.distantPast...Date.distantFuture
    ) {
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
    static let accessibilityHint: Self = "Double-tap to change."
}
