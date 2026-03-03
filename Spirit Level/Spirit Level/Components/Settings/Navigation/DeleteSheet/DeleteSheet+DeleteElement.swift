import SwiftUI

extension DeleteSheet {
    struct DeleteElement: View {
        @Binding private var isOn: Bool
        private let title: LocalizedStringResource
        private let description: LocalizedStringResource

        init(title: LocalizedStringResource,
             description: LocalizedStringResource,
             isOn: Binding<Bool>) {
            self.title = title
            self.description = description
            self._isOn = isOn
        }

        var body: some View {
            VStack {
                Toggle(title, isOn: $isOn)
                Text(description)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(title)
            .accessibilityAction(named: LocalizedStringResource("Explain consequences")) {
                UIAccessibility.post(
                    notification: .announcement,
                    argument: String(localized: description)
                )
            }
        }
    }
}
