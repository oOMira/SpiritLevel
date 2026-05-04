import SwiftUI

/// A text field that only accepts numeric input, with a title label and VoiceOver support.
///
/// Non-numeric characters are automatically stripped as the user types.
struct AccessibleNumberPicker: View {
    /// The localized heading displayed above the text field.
    let title: LocalizedStringResource
    /// The localized placeholder text shown when the field is empty.
    let placeholder: LocalizedStringResource
    /// The current numeric string value entered by the user.
    @Binding var value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField(placeholder, text: $value)
                .keyboardType(.numberPad)
                .onChange(of: value) { _, newValue in
                    let numbers = newValue.filter { $0.isNumber }
                    if numbers != newValue {
                        value = numbers
                    }
                }
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint(.accessibilityHint)
    }
}

private extension LocalizedStringResource {
    static let accessibilityHint: Self = "Double tap to edit the number"
}
