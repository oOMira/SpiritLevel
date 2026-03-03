import SwiftUI

struct AccessibleNumberPicker: View {
    let title: LocalizedStringResource
    let placeholder: LocalizedStringResource
    @Binding var value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField(placeholder, text: $value)
                .keyboardType(.numberPad)
                .onChange(of: value) { oldValue, newValue in
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
