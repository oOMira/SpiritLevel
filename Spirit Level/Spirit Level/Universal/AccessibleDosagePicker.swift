import SwiftUI

struct AccessibleDosagePicker: View {
    @Binding var dosage: Double
    
    var body: some View {
        HStack {
            Text("\(LocalizedStringResource.dosageLabel):")
            Stepper(label: {
                Text("\(dosage, specifier: .dosageFormat) mg")
            }, onIncrement: {
                increase()
            }, onDecrement: {
                decrease()
            })
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(.dosageLabel)
        .accessibilityValue("\(dosage, specifier: .dosageFormat) mg")
    }
    
    private func increase() {
        dosage += .doseStep
    }
    
    private func decrease() {
        dosage -= .doseStep
    }
}

// MARK: - Constants

private extension LocalizedStringResource {
    static let dosageLabel: Self = "Dosage"
}

private extension String {
    static let dosageFormat = "%.1f"
}

private extension Double {
    static let doseStep: Self = 0.1
}
