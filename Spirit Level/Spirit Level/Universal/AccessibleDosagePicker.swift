import SwiftUI

/// A stepper-based picker for adjusting hormone dosage values in 0.1 mg increments.
///
/// Displays the current dosage formatted to one decimal place and provides
/// combined VoiceOver accessibility for the label and value.
struct AccessibleDosagePicker: View {
    /// The current dosage in milligrams.
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
    
    /// Increases the dosage by one step (0.1 mg).
    private func increase() {
        dosage += .doseStep
    }
    
    /// Decreases the dosage by one step (0.1 mg).
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
