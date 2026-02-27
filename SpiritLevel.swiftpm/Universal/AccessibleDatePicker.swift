import SwiftUI

struct AccessibleDatePicker: View {
    let title: LocalizedStringResource
    @Binding private var selectedDate: Date
    
    init(title: LocalizedStringResource, selectedDate: Binding<Date>) {
        self.title = title
        self._selectedDate = selectedDate
    }

    var body: some View {
        DatePicker(title,
                   selection: $selectedDate,
                   displayedComponents: .date)
        .accessibilityElement(children: .combine)
        .accessibilityValue(selectedDate.formatted(date: .abbreviated, time: .omitted))
        .accessibilityHint(.accessibilityHint)
    }
}

private extension LocalizedStringResource {
    static let accessibilityHint: Self = "Double tap to change"
}
