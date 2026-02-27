import SwiftUI

struct AccessibleDosagePicker: View {
    @Binding var dosage: Double
    
    var body: some View {
        HStack {
            Text("\(LocalizedStringResource.doseageLabel):")
            Stepper(label: {
                Text("\(dosage, specifier: .doseageFormat) mg")
            }, onIncrement: {
                increase()
            }, onDecrement: {
                decrease()
            })
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(.doseageLabel)
        .accessibilityValue("\(dosage, specifier: .doseageFormat) mg")
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
    static let doseageLabel: Self = "Doseage"
}
    
private extension String {
    static let doseageFormat = "%.1f"
}

private extension Double {
    static let doseStep: Self = 0.1
}
